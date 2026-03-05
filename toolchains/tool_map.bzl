# Copyright 2025 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Implementation of tool_map."""

load(
    "//toolchains/private:collect.bzl",
    "collect_provider",
    "collect_tools",
)
load(
    ":toolchain_info.bzl",
    "ActionTypeSetInfo",
    "ToolMapInfo",
)

def _tool_map_impl(ctx):
    tools = collect_tools(ctx, ctx.attr.tools)
    action_sets = collect_provider(ctx.attr.actions, ActionTypeSetInfo)

    action_to_tool = {}
    action_to_as = {}
    for i in range(len(action_sets)):
        action_set = action_sets[i]
        tool = tools[ctx.attr.tool_index_for_action[i]]

        for action in action_set.actions.to_list():
            if action in action_to_as:
                fail("The action %s appears multiple times in your tool_map (as %s and %s)" % (action.label, action_set.label, action_to_as[action].label))
            action_to_as[action] = action_set
            action_to_tool[action.label] = tool

    return [ToolMapInfo(label = ctx.label, configs = action_to_tool)]

_tool_map = rule(
    implementation = _tool_map_impl,
    # @unsorted-dict-items
    attrs = {
        "actions": attr.label_list(
            providers = [ActionTypeSetInfo],
            mandatory = True,
            doc = """A list of action names to apply this action to.

See //toolchains/actions:BUILD for valid options.
""",
        ),
        "tools": attr.label_list(
            mandatory = True,
            cfg = "exec",
            allow_files = True,
            doc = """The tool to use for the specified actions.

The tool may be a `tool` or other executable rule.
""",
        ),
        "tool_index_for_action": attr.int_list(
            mandatory = True,
            doc = """The index of the tool in `tools` for the action in `actions`.""",
        ),
    },
    provides = [ToolMapInfo],
)

def tool_map(name, tools, **kwargs):
    """A toolchain configuration rule that maps toolchain actions to tools.

    A `tool_map` aggregates all the tools that may be used for a given toolchain
    and maps them to their corresponding actions. Conceptually, this is similar to the
    `CXX=/path/to/clang++` environment variables that most build systems use to determine which
    tools to use for a given action. To simplify usage, some actions have been grouped together (for
    example,
    [@rules_cc//toolchains/actions:cpp_compile_actions](https://github.com/matts1/rules_toolchains/tree/main/toolchains/actions/BUILD)) to
    logically express "all the C++ compile actions".

    Example usage:
    ```
    load("//toolchains:tool_map.bzl", "tool_map")

    tool_map(
        name = "all_tools",
        tools = {
            "//toolchains/actions:assembly_actions": ":asm",
            "//toolchains/actions:c_compile": ":clang",
            "//toolchains/actions:cpp_compile_actions": ":clang++",
            "//toolchains/actions:link_actions": ":lld",
            "//toolchains/actions:objcopy_embed_data": ":llvm-objcopy",
            "//toolchains/actions:strip": ":llvm-strip",
            "//toolchains/actions:ar_actions": ":llvm-ar",
        },
    )
    ```

    Args:
        name: (str) The name of the target.
        tools: (Dict[Label, Label]) A mapping between
            `action_type`/`action_type_set` targets
            and the `tool` or executable target that implements that action.
        **kwargs: [common attributes](https://bazel.build/reference/be/common-definitions#common-attributes) that should be applied to this rule.
    """
    actions = []
    tool_index_for_action = []
    deduplicated_tools = {}
    for action, tool in tools.items():
        actions.append(action)
        label = native.package_relative_label(tool)
        if label not in deduplicated_tools:
            deduplicated_tools[label] = len(deduplicated_tools)
        tool_index_for_action.append(deduplicated_tools[label])

    _tool_map(
        name = name,
        actions = actions,
        tools = deduplicated_tools.keys(),
        tool_index_for_action = tool_index_for_action,
        **kwargs
    )
