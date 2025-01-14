<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Implementation of the feature rule.

<a id="feature"></a>

## feature

<pre>
load("@rules_toolchains//toolchains:feature.bzl", "feature")

feature(<a href="#feature-name">name</a>, <a href="#feature-args">args</a>, <a href="#feature-implies">implies</a>, <a href="#feature-mutually_exclusive">mutually_exclusive</a>, <a href="#feature-requires">requires</a>)
</pre>

A dynamic set of toolchain flags that create a singular [feature](https://bazel.build/docs/cc-toolchain-config-reference#features) definition.

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

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="feature-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="feature-args"></a>args |  A list of `args` or `args_list` labels that are expanded when this feature is enabled.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="feature-implies"></a>implies |  List of features to be enabled when this feature is enabled.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="feature-mutually_exclusive"></a>mutually_exclusive |  A list of things that this feature is mutually exclusive with.<br><br>It can be either: * A feature, in which case the two features are mutually exclusive. * A `mutually_exclusive_category`, in which case all features that write     `mutually_exclusive = [":category"]` are mutually exclusive with each other.<br><br>This is useful for incompatibilities, or for something akin to an enum (eg. opt/debug/fastbuild).   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="feature-requires"></a>requires |  A list of feature sets that define toolchain compatibility.<br><br>If *at least one* of the listed `feature_set`s are fully satisfied (all features are currently enabled), this feature is deemed compatible and may be enabled.<br><br>Note: Even if `feature.requires` is satisfied, a feature is not enabled unless another mechanism (e.g. `toolchain_config.default_features`, `enabled_features`) signals that the feature should actually be enabled.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |


