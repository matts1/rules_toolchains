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
"""Implementation of the feature_set rule."""

load("//toolchains/private:collect.bzl", "collect_features")
load("//toolchains/private:features.bzl", "create_constraint")
load(
    ":toolchain_info.bzl",
    "FeatureConstraintInfo",
    "FeatureSetInfo",
)

def _feature_set_impl(ctx):
    if ctx.attr.features:
        fail("Features is a reserved attribute in bazel. feature_set takes `all_of` instead.")
    features = collect_features(ctx.attr.all_of)
    constraints = [target[FeatureConstraintInfo] for target in ctx.attr.all_of]
    return [
        FeatureSetInfo(label = ctx.label, features = features),
        create_constraint(
            label = ctx.label,
            all_of = constraints,
            any_of = [],
            none_of = [],
        ),
    ]

feature_set = rule(
    implementation = _feature_set_impl,
    attrs = {
        "all_of": attr.label_list(
            providers = [FeatureSetInfo],
            doc = "A set of features",
        ),
    },
    provides = [FeatureSetInfo, FeatureConstraintInfo],
    doc = """Defines a set of features.

This may be used by both `feature` and `args` rules, and is effectively a way to express
a logical `AND` operation across multiple required features.

Example:
```
load("//toolchains:feature_set.bzl", "feature_set")

feature_set(
    name = "thin_lto_requirements",
    all_of = [
        ":thin_lto",
        ":opt",
    ],
)
```
""",
)
