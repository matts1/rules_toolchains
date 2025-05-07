# Copyright 2023 The Bazel Authors. All rights reserved.
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
"""Implementation of tool"""

load("//toolchains/private:collect.bzl", "collect_data")
load(
    ":toolchain_info.bzl",
    "ToolCapabilityInfo",
    "ToolInfo",
)

def _tool_impl(ctx):
    exe_info = ctx.attr.src[DefaultInfo]
    if exe_info.files_to_run != None and exe_info.files_to_run.executable != None:
        exe = exe_info.files_to_run.executable
    elif len(exe_info.files.to_list()) == 1:
        exe = exe_info.files.to_list()[0]
    else:
        fail("Expected tool's src attribute to be either an executable or a single file")

    data = collect_data(ctx.attr.data + [ctx.attr.src])
    tool = ToolInfo(
        label = ctx.label,
        exe = exe,
        files_to_run = data,
        execution_requirements = ctx.attr.execution_requirements,
        capabilities = tuple([target[ToolCapabilityInfo] for target in ctx.attr.capabilities]),
    )

    link = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.symlink(
        output = link,
        target_file = exe,
        is_executable = True,
    )
    return [
        tool,
        # This isn't required, but now we can do "bazel run <tool>", which can
        # be very helpful when debugging toolchains.
        DefaultInfo(
            files = depset([link]),
            runfiles = ctx.runfiles(transitive_files = depset(transitive = [element for element in data if type(element) == "depset"])),
            executable = link,
        ),
    ]

tool = rule(
    implementation = _tool_impl,
    # @unsorted-dict-items
    attrs = {
        "src": attr.label(
            allow_files = True,
            doc = """The underlying binary that this tool represents.

Usually just a single prebuilt (eg. @toolchain//:bin/clang), but may be any
executable label.
""",
        ),
        "data": attr.label_list(
            allow_files = True,
            doc = """Additional files that are required for this tool to run.

Frequently, clang and gcc require additional files to execute as they often shell out to
other binaries (e.g. `cc1`).
""",
        ),
        "capabilities": attr.label_list(
            providers = [ToolCapabilityInfo],
            doc = """Declares that a tool is capable of doing something.

For example, `@rules_cc//toolchains/capabilities:supports_pic`.
""",
        ),
        "execution_requirements": attr.string_dict(),
    },
    provides = [ToolInfo],
    doc = """Declares a tool for use by toolchain actions.

`tool` rules are used in a `tool_map` rule to ensure all files and
metadata required to run a tool are available when constructing a `toolchain`.

In general, include all files that are always required to run a tool (e.g. libexec/** and
cross-referenced tools in bin/*) in the [data](#tool-data) attribute. If some files are only
required when certain flags are passed to the tool, consider using a `args` rule to
bind the files to the flags that require them. This reduces the overhead required to properly
enumerate a sandbox with all the files required to run a tool, and ensures that there isn't
unintentional leakage across configurations and actions.

Example:
```
load("//toolchains:tool.bzl", "tool")

tool(
    name = "clang_tool",
    src = "@llvm_toolchain//:bin/clang",
    # Suppose clang needs libc to run.
    data = ["@llvm_toolchain//:lib/x86_64-linux-gnu/libc.so.6"]
    execution_requirements = {"requires-network": ""},
    capabilities = ["//toolchains/capabilities:supports_pic"],
)
```
""",
    executable = True,
)
