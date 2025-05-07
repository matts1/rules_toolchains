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
"""Implementation of the feature rule."""

load(
    "//toolchains/private:collect.bzl",
    "collect_args_lists",
    "collect_features",
)
load("//toolchains/private:small_set.bzl", "create_small_set")
load(
    ":toolchain_info.bzl",
    "ArgsListInfo",
    "FeatureConstraintInfo",
    "FeatureInfo",
    "FeatureSetInfo",
    "MutuallyExclusiveCategoryInfo",
)

def _feature_impl(ctx):
    args = collect_args_lists(ctx.attr.args)
    feature = FeatureInfo(
        label = ctx.label,
        args = args,
        implies = collect_features([target[FeatureSetInfo] for target in ctx.attr.implies]),
        requires = tuple([target[FeatureConstraintInfo] for target in ctx.attr.requires]),
        mutually_exclusive = tuple([target[MutuallyExclusiveCategoryInfo] for target in ctx.attr.mutually_exclusive]),
    )

    feature_set = create_small_set([feature])

    def validate(self, features):
        if self.label not in features:
            return "%s is disabled" % self.label
        return None

    return [
        feature,
        FeatureSetInfo(label = ctx.label, features = feature_set),
        FeatureConstraintInfo(
            label = ctx.label,
            storage = None,
            validate = validate,
        ),
        MutuallyExclusiveCategoryInfo(label = ctx.label),
    ]

feature = rule(
    implementation = _feature_impl,
    # @unsorted-dict-items
    attrs = {
        "args": attr.label_list(
            doc = """A list of `args` or `args_list` labels that are expanded when this feature is enabled.""",
            providers = [ArgsListInfo],
        ),
        "requires": attr.label_list(
            doc = """A list of feature sets that define toolchain compatibility.

If *at least one* of the listed `feature_set`s are fully satisfied (all
features are currently enabled), this feature is deemed compatible and may be
enabled.

Note: Even if `feature.requires` is satisfied, a feature is not
enabled unless another mechanism (e.g. `toolchain_config.default_features`,
`enabled_features`) signals that the feature should actually be enabled.
""",
            providers = [FeatureConstraintInfo],
        ),
        "implies": attr.label_list(
            providers = [FeatureSetInfo],
            doc = """List of features to be enabled when this feature is enabled.""",
        ),
        "mutually_exclusive": attr.label_list(
            providers = [MutuallyExclusiveCategoryInfo],
            doc = """A list of things that this feature is mutually exclusive with.

It can be either:
* A feature, in which case the two features are mutually exclusive.
* A `mutually_exclusive_category`, in which case all features that write
    `mutually_exclusive = [":category"]` are mutually exclusive with each other.

This is useful for incompatibilities, or for something akin to an enum
(eg. opt/debug/fastbuild).
""",
        ),
    },
    provides = [
        FeatureInfo,
        FeatureSetInfo,
        FeatureConstraintInfo,
        MutuallyExclusiveCategoryInfo,
    ],
    doc = """A dynamic set of toolchain flags that create a singular [feature](https://bazel.build/docs/cc-toolchain-config-reference#features) definition.

A feature is basically a dynamically toggleable `args_list`. There are a variety of
dependencies and compatibility requirements that must be satisfied to enable a
`feature`. Once those conditions are met, the arguments in [`feature.args`](#feature-args)
are expanded and added to the command-line.

A feature may be enabled or disabled through the following mechanisms:
* toolchain_config.features
* Through inter-feature relationships (via [`feature.implies`](#feature-implies)) where one
  feature may implicitly enable another.
* Individual rules (e.g. `cc_library`) or `package` definitions may elect to manually enable or
  disable features through the `disabled_features` or `enabled_features`

Note that a feature may alternate between enabled and disabled dynamically over the course of a
build. Because of their toggleable nature, it's recommended to add unconditional arguments as
a feature with private visibility wherever possible.

You should use a `feature` when any of the following apply:
* You need the flags to be dynamically toggled over the course of a build.
* You want build files to be able to configure the flags in question. For example, a
  binary might specify `enabled_features = ["//features:optimize_for_size"]` to create a small
  binary instead of optimizing for performance.

If you only need to configure flags via the Bazel command-line, instead
consider adding a
[`bool_flag`](https://github.com/bazelbuild/bazel-skylib/tree/main/doc/common_settings_doc.md#bool_flag)
paired with a [`config_setting`](https://bazel.build/reference/be/general#config_setting)
and then make your `args_add_*` rules `select` on the `config_setting`.

For more details about how Bazel handles features, see the official Bazel
documentation at
https://bazel.build/docs/cc-toolchain-config-reference#features.

Example:
```
load("//toolchains:feature.bzl", "feature")

# A feature that enables LTO, which may be incompatible when doing interop with various
# languages (e.g. rust, go), or may need to be disabled for particular `cc_binary` rules
# for various reasons.
feature(
    name = "lto",
    args = [":lto_args"],
)
```
""",
)
