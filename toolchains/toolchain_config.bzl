# Copyright 2025 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Implementation of the toolchain rule."""

load(
    "//toolchains:toolchain_info.bzl",
    "FeatureSetInfo",
    "ToolMapInfo",
    "ToolchainConfigInfo",
)
load("//toolchains/private:action.bzl", "resolve_action")
load("//toolchains/private:collect.bzl", "collect_features", "collect_provider")
load("//toolchains/private:features.bzl", "get_features")

visibility("public")

def _create_toolchain(*, label, enabled_features, tool_map):
    capabilities_to_features = {}
    defaults = {}
    for action_type, tool in tool_map.configs.items():
        capabilities = tuple(sorted([cap.label for cap in tool.capabilities]))
        if capabilities not in capabilities_to_features:
            capabilities_to_features[capabilities] = get_features(list(enabled_features) + [cap.feature for cap in tool.capabilities], [], [])
        features = capabilities_to_features[capabilities]
        defaults[action_type] = resolve_action(action_type = action_type, features = features, extra_args = [])

    return ToolchainConfigInfo(
        label = label,
        enabled_features = enabled_features,
        defaults_by_action = defaults,
        tool_map = tool_map,
    )

def _toolchain_config_impl(ctx):
    if ctx.attr.features:
        fail("Features is a reserved attribute in bazel. Did you mean 'default_features'?")

    toolchain_config = _create_toolchain(
        label = ctx.label,
        enabled_features = collect_features(collect_provider(ctx.attr.default_features, FeatureSetInfo)),
        tool_map = ctx.attr.tool_map[ToolMapInfo],
    )

    return [
        toolchain_config,
        platform_common.ToolchainInfo(config = toolchain_config),
    ]

toolchain_config = rule(
    implementation = _toolchain_config_impl,
    attrs = {
        # Explicitly do not support always enabled args, as it leads to more
        # ambiguity WRT argument ordering.
        # If you want an always enabled arg, just put it in default enabled
        # features and make the visibility of the feature private so no-one
        # can turn it off.
        "default_features": attr.label_list(providers = [FeatureSetInfo]),
        "tool_map": attr.label(providers = [ToolMapInfo], mandatory = True),
    },
    provides = [platform_common.ToolchainInfo],
)
