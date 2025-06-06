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
load("//toolchains/private:collect.bzl", "collect_features")
load("//toolchains/private:features.bzl", "get_features")

visibility("public")

LINUX_AMD64 = ["@platforms//os:linux", "@platforms//cpu:x86_64"]
LINUX_ARM64 = ["@platforms//os:linux", "@platforms//cpu:aarch64"]
MAC_AMD64 = ["@platforms//os:osx", "@platforms//cpu:x86_64"]
MAC_ARM64 = ["@platforms//os:osx", "@platforms//cpu:aarch64"]
WINDOWS_AMD64 = ["@platforms//os:windows", "@platforms//cpu:x86_64"]
WINDOWS_ARM64 = ["@platforms//os:windows", "@platforms//cpu:aarch64"]

NO_REMOTE_EXECUTION = {None: []}
DEFAULT_EXEC_CONSTRAINT_GROUPS = {
    "linux_amd64": LINUX_AMD64,
    "linux_arm64": LINUX_ARM64,
    "mac_amd64": MAC_AMD64,
    "mac_arm64": MAC_ARM64,
    "windows_amd64": WINDOWS_AMD64,
    "windows_arm64": WINDOWS_ARM64,
}

_NO_EXEC_CONSTRAINT_GROUPS_ERROR = """You did not specify a set of execution platforms for your toolchain.

This is needed if you are using remote execution. If you don't intend to use remote execution, set exec_constraint_groups = NO_REMOTE_EXECUTION

If you do have remote execution, each execution platform (both remote and local) that might result in a different configuration (eg. different tool binaries) should be listed.

A reasonable set of defaults is DEFAULT_EXEC_PLATFORMS, which provides amd64 and arm64 variants for linux, mac, and windows.

For example, if all your devs use linux amd64 machines locally, and your remote execution machines are linux arm64 machines, you would write:
```
{
    "linux_amd64": ["@platforms//os:linux", "@platforms//cpu:x86_64"]
    "linux_arm64": ["@platforms//os:linux", "@platforms//cpu:aarch64"]
}
```
"""

def _create_toolchain(*, label, enabled_features, tool_map):
    capabilities_to_features = {}
    defaults = {}
    for action_type, tool in tool_map.configs.items():
        capabilities = tuple(sorted([cap.label for cap in tool.capabilities]))
        if capabilities not in capabilities_to_features:
            capabilities_to_features[capabilities] = get_features(enabled_features + [cap.feature for cap in tool.capabilities], [], [])
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
        enabled_features = collect_features(ctx.attr.default_features).to_list(),
        tool_map = ctx.attr.tool_map[ToolMapInfo],
    )

    return [
        toolchain_config,
        platform_common.ToolchainInfo(config = toolchain_config),
    ]

_toolchain_config = rule(
    implementation = _toolchain_config_impl,
    attrs = {
        # Explicitly do not support always enabled args, as it leads to more
        # ambiguity WRT argument ordering.
        # If you want an always enabled arg, just put it in default enabled
        # features and make the visibility of the feature private so no-one
        # can turn it off.
        "default_features": attr.label_list(providers = [FeatureSetInfo]),
        "tool_map": attr.label(providers = [ToolMapInfo], cfg = "exec", mandatory = True),
    },
    provides = [platform_common.ToolchainInfo],
)

def toolchain(
        name,
        default_features,
        tool_map,
        toolchain_type,
        exec_constraint_groups = None):
    """Toolchain for a given toolchain type.

    Args:
        name: (str) The prefix given to all toolchains.
          This will create one toolchain target per exec platform.
        default_features: (List[Label]) A list of labels corresponding to
          features that are enabled by default.
        tool_map: (Label) A tool map created by the `tool_map` rule.
        toolchain_type: (Label) The type of toolchain this corresponds to.
        exec_constraint_groups: (Dict[str, List[Label]])
          A mapping from toolchain suffix to a list of constraints.
    """
    config_name = "_%s_config" % name
    _toolchain_config(
        name = config_name,
        default_features = default_features,
        tool_map = tool_map,
        visibility = ["//visibility:private"],
    )

    if not exec_constraint_groups:
        fail(_NO_EXEC_CONSTRAINT_GROUPS_ERROR)
    for suffix, constraints in exec_constraint_groups.items():
        toolchain_name = name if suffix == None else "%s_%s" % (name, suffix)

        native.toolchain(
            name = toolchain_name,
            toolchain = config_name,
            toolchain_type = toolchain_type,
            exec_compatible_with = constraints,
        )
