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
"""Implementation of the feature_constraint rule."""

load("//toolchains/private:features.bzl", "create_constraint")
load(
    ":toolchain_info.bzl",
    "FeatureConstraintInfo",
)

def _feature_constraint_impl(ctx):
    if ctx.attr.features:
        fail("Features is a reserved attribute in bazel. Use the attributes `all_of` and `none_of` for feature constraints")
    return [create_constraint(
        label = ctx.label,
        all_of = [target[FeatureConstraintInfo] for target in ctx.attr.all_of],
        any_of = [target[FeatureConstraintInfo] for target in ctx.attr.any_of],
        none_of = [target[FeatureConstraintInfo] for target in ctx.attr.none_of],
    )]

feature_constraint = rule(
    implementation = _feature_constraint_impl,
    attrs = {
        "any_of": attr.label_list(
            providers = [FeatureConstraintInfo],
        ),
        "all_of": attr.label_list(
            providers = [FeatureConstraintInfo],
        ),
        "none_of": attr.label_list(
            providers = [FeatureConstraintInfo],
        ),
    },
    provides = [FeatureConstraintInfo],
    doc = """Defines a compound relationship between features.

This rule can be used with `args.require` or `feature.require` to specify that something is
only valid. `all_of`, `none_of`, and `any_of` must be satisfied simultaneously.

Example:
```
load("//toolchains:feature_constraint.bzl", "feature_constraint")

# A constraint that requires a `linker_supports_thinlto` feature to be enabled,
# AND a `no_optimization` to be disabled.
feature_constraint(
    name = "thinlto_constraint",
    all_of = [":linker_supports_thinlto"],
    none_of = [":no_optimization"],
)
```
""",
)
