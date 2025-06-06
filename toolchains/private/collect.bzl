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
"""Helper functions to allow us to collect data from attr.label_list."""

load(
    "//toolchains:toolchain_info.bzl",
    "ActionTypeSetInfo",
    "ArgsListInfo",
    "FeatureSetInfo",
    "ToolInfo",
)

visibility([
    "//toolchains/...",
    "//tests/...",
])

def _make_collector(provider, field):
    def collector(targets, direct = [], transitive = []):
        # Avoid mutating what was passed in.
        transitive = transitive[:]
        for target in targets:
            transitive.append(getattr(target[provider], field))
        return depset(direct = direct, transitive = transitive)

    return collector

collect_action_types = _make_collector(ActionTypeSetInfo, "actions")

def collect_action_labels(actions):
    return [action.label for action in collect_action_types(actions).to_list()]

collect_files = _make_collector(DefaultInfo, "files")

def collect_data(ctx, targets):
    """Collects from a 'data' attribute.

    This is distinguished from collect_files by the fact that data attributes
    attributes include runfiles.

    Args:
        ctx: Bazel's ctx object
        targets: (List[Target]) A list of files or executables

    Returns:
        A runfiles object
    """
    runfiles = []
    transitive_files = []
    for target in targets:
        info = target[DefaultInfo]
        if info.default_runfiles != None:
            runfiles.append(info.data_runfiles)
        if info.files != None:
            transitive_files.append(info.files)

    return ctx.runfiles(transitive_files = depset(transitive = transitive_files)).merge_all(runfiles)

def collect_features(targets):
    return depset(transitive = [target[FeatureSetInfo].features for target in targets])

def collect_tools(ctx, targets, fail = fail):
    """Collects tools from a label_list.

    Each entry in the label list may either be a tool or a binary.

    Args:
        ctx: (Context) The ctx for the current rule
        targets: (List[Target]) A list of targets. Each of these targets may be
          either a tool or an executable.
        fail: (function) The fail function. Should only be used in tests.

    Returns:
        A List[ToolInfo], with regular executables creating custom tool info.
    """
    tools = []
    for target in targets:
        info = target[DefaultInfo]
        if ToolInfo in target:
            tools.append(target[ToolInfo])
        elif info.files_to_run != None and info.files_to_run.executable != None:
            tools.append(ToolInfo(
                label = target.label,
                exe = info.files_to_run.executable,
                runfiles = collect_data(ctx, [target]),
                execution_requirements = {},
                allowlist_include_directories = depset(),
                capabilities = tuple(),
            ))
        else:
            fail("Expected %s to be a tool or a binary rule" % target.label)

    return tools

def collect_args_lists(targets):
    """Collects a label_list of ArgsListInfo into a single ArgsListInfo

    Args:
        targets: (List[Target]) A label_list of targets providing ArgsListInfo
    Returns:
        A sequence of args corresponding to their merged arg lists.
    """
    args = []
    for target in targets:
        args_list = target[ArgsListInfo]
        args.extend(args_list.args)

    return tuple(args)
