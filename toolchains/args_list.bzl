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
"""All providers for rule-based bazel toolchain config."""

load(
    "//toolchains/private:collect.bzl",
    "collect_args_lists",
)
load(":toolchain_info.bzl", "ArgsListInfo")

def _args_list_impl(ctx):
    return [ArgsListInfo(label = ctx.label, args = collect_args_lists(ctx.attr.args))]

args_list = rule(
    implementation = _args_list_impl,
    doc = """An ordered list of args.

    This is a convenience rule to allow you to group a set of multiple `args_add_*` into a
    single list. This particularly useful for toolchain behaviors that require different flags for
    different actions.

    Note: The order of the arguments in `args` is preserved to support order-sensitive flags.

    Example usage:
    ```
    load("//toolchains:args.bzl", "args_add", "args_add_strings")
    load("//toolchains:args_list.bzl", "args_list")

    args_add_strings(name = "foo", ...)
    args_add_strings(name = "bar", ...)

    args_list(
        name = "gc_functions",
        args = [
            ":foo",
            ":bar",
        ],
    )
    ```
    """,
    attrs = {
        "args": attr.label_list(
            providers = [ArgsListInfo],
            doc = "(ordered) args to include in this list.",
        ),
    },
    provides = [ArgsListInfo],
)
