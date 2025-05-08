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
"""Rule for mutually exclusive categories in the rule based toolchain."""

load(":toolchain_info.bzl", "MutuallyExclusiveCategoryInfo")

def _mutually_exclusive_category_impl(ctx):
    return [MutuallyExclusiveCategoryInfo(
        label = ctx.label,
    )]

mutually_exclusive_category = rule(
    implementation = _mutually_exclusive_category_impl,
    doc = """A rule used to categorize `feature` definitions for which only one can be enabled.

This is used by [`feature.mutually_exclusive`](#feature-mutually_exclusive) to express groups
of `feature` definitions that are inherently incompatible with each other and must be treated as
mutually exclusive.

Warning: These groups are keyed by name, so two `mutually_exclusive_category` definitions of the
same name in different packages will resolve to the same logical group.

Example:
```
load("//toolchains:feature.bzl", "feature")
load("//toolchains:mutually_exclusive_category.bzl", "mutually_exclusive_category")

mutually_exclusive_category(
    name = "opt_level",
)

feature(
    name = "speed_optimized",
    mutually_exclusive = [":opt_level"],
)

feature(
    name = "size_optimized",
    mutually_exclusive = [":opt_level"],
)

feature(
    name = "unoptimized",
    mutually_exclusive = [":opt_level"],
)
```
""",
    attrs = {},
    provides = [MutuallyExclusiveCategoryInfo],
)
