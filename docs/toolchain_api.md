<!-- Generated with Stardoc: http://skydoc.bazel.build -->

This is a list of rules/macros that should be exported as documentation.

<a id="action_type"></a>

## action_type

<pre>
load("@rules_toolchains//toolchains/private:documented_api.bzl", "action_type")

action_type(<a href="#action_type-name">name</a>, <a href="#action_type-mnemonic">mnemonic</a>)
</pre>

A type of action (eg. c_compile, assemble, strip).

[`action_type`](#action_type) rules are used to associate arguments and tools together to
perform a specific action. Bazel prescribes a set of known action types that are used to drive
typical C/C++/ObjC actions like compiling, linking, and archiving. The set of well-known action
types can be found in [@rules_cc@rules_toolchains//toolchains/actions:BUILD](https://github.com/matts1/rules_toolchains/tree/main/toolchains/actions/BUILD).

It's possible to create project-specific action types for use in toolchains. Be careful when
doing this, because every toolchain that encounters the action will need to be configured to
support the custom action type. If your project is a library, avoid creating new action types as
it will reduce compatibility with existing toolchains and increase setup complexity for users.

Example:
```
load("@rules_toolchains//toolchains:actions.bzl", "action_type")

action_type(
    name = "cpp_compile",
)
```

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="action_type-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="action_type-mnemonic"></a>mnemonic |  -   | String | required |  |


<a id="action_type_set"></a>

## action_type_set

<pre>
load("@rules_toolchains//toolchains/private:documented_api.bzl", "action_type_set")

action_type_set(<a href="#action_type_set-name">name</a>, <a href="#action_type_set-actions">actions</a>, <a href="#action_type_set-allow_empty">allow_empty</a>)
</pre>

Represents a set of actions.

This is a convenience rule to allow for more compact representation of a group of action types.
Use this anywhere a [`action_type`](#action_type) is accepted.

Example:
```
load("@rules_toolchains//toolchains:actions.bzl", "action_type_set")

action_type_set(
    name = "link_executable_actions",
    actions = [
        "@rules_toolchains//toolchains/actions:cpp_link_executable",
        "@rules_toolchains//toolchains/actions:lto_index_for_executable",
    ],
)
```

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="action_type_set-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="action_type_set-actions"></a>actions |  A list of action_type or action_type_set   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="action_type_set-allow_empty"></a>allow_empty |  -   | Boolean | optional |  `False`  |


<a id="args_add"></a>

## args_add

<pre>
load("@rules_toolchains//toolchains/private:documented_api.bzl", "args_add")

args_add(<a href="#args_add-name">name</a>, <a href="#args_add-data">data</a>, <a href="#args_add-actions">actions</a>, <a href="#args_add-arg_name">arg_name</a>, <a href="#args_add-env">env</a>, <a href="#args_add-format">format</a>, <a href="#args_add-omit_if_missing">omit_if_missing</a>, <a href="#args_add-requires_any_of">requires_any_of</a>, <a href="#args_add-value">value</a>)
</pre>

Declares a list of arguments bound to a set of actions.

Roughly equivalent to ctx.actions.args().add()

Examples:
    args_add(
        name = "warnings_as_errors",
        format = string
        value = <label>
        args = ["-Werror"],
    )

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="args_add-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="args_add-data"></a>data |  -   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="args_add-actions"></a>actions |  See documentation for args macro wrapper.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="args_add-arg_name"></a>arg_name |  -   | String | optional |  `""`  |
| <a id="args_add-env"></a>env |  See documentation for args macro wrapper.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="args_add-format"></a>format |  See documentation for args.add   | String | optional |  `""`  |
| <a id="args_add-omit_if_missing"></a>omit_if_missing |  -   | Boolean | optional |  `False`  |
| <a id="args_add-requires_any_of"></a>requires_any_of |  See documentation for args macro wrapper.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="args_add-value"></a>value |  -   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |


<a id="args_add_all"></a>

## args_add_all

<pre>
load("@rules_toolchains//toolchains/private:documented_api.bzl", "args_add_all")

args_add_all(<a href="#args_add_all-name">name</a>, <a href="#args_add_all-data">data</a>, <a href="#args_add_all-actions">actions</a>, <a href="#args_add_all-allow_closure">allow_closure</a>, <a href="#args_add_all-allow_missing">allow_missing</a>, <a href="#args_add_all-arg_name">arg_name</a>, <a href="#args_add_all-before_each">before_each</a>, <a href="#args_add_all-env">env</a>,
             <a href="#args_add_all-expand_directories">expand_directories</a>, <a href="#args_add_all-format_each">format_each</a>, <a href="#args_add_all-omit_if_empty">omit_if_empty</a>, <a href="#args_add_all-omit_if_missing">omit_if_missing</a>, <a href="#args_add_all-requires_any_of">requires_any_of</a>,
             <a href="#args_add_all-terminate_with">terminate_with</a>, <a href="#args_add_all-uniquify">uniquify</a>, <a href="#args_add_all-value">value</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="args_add_all-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="args_add_all-data"></a>data |  -   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="args_add_all-actions"></a>actions |  See documentation for args macro wrapper.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="args_add_all-allow_closure"></a>allow_closure |  -   | Boolean | optional |  `False`  |
| <a id="args_add_all-allow_missing"></a>allow_missing |  -   | Boolean | optional |  `False`  |
| <a id="args_add_all-arg_name"></a>arg_name |  -   | String | optional |  `""`  |
| <a id="args_add_all-before_each"></a>before_each |  -   | String | optional |  `""`  |
| <a id="args_add_all-env"></a>env |  See documentation for args macro wrapper.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="args_add_all-expand_directories"></a>expand_directories |  -   | Boolean | optional |  `True`  |
| <a id="args_add_all-format_each"></a>format_each |  -   | String | optional |  `""`  |
| <a id="args_add_all-omit_if_empty"></a>omit_if_empty |  -   | Boolean | optional |  `True`  |
| <a id="args_add_all-omit_if_missing"></a>omit_if_missing |  -   | Boolean | optional |  `False`  |
| <a id="args_add_all-requires_any_of"></a>requires_any_of |  See documentation for args macro wrapper.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="args_add_all-terminate_with"></a>terminate_with |  -   | String | optional |  `""`  |
| <a id="args_add_all-uniquify"></a>uniquify |  -   | Boolean | optional |  `False`  |
| <a id="args_add_all-value"></a>value |  -   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |


<a id="args_add_joined"></a>

## args_add_joined

<pre>
load("@rules_toolchains//toolchains/private:documented_api.bzl", "args_add_joined")

args_add_joined(<a href="#args_add_joined-name">name</a>, <a href="#args_add_joined-data">data</a>, <a href="#args_add_joined-actions">actions</a>, <a href="#args_add_joined-arg_name">arg_name</a>, <a href="#args_add_joined-env">env</a>, <a href="#args_add_joined-expand_directories">expand_directories</a>, <a href="#args_add_joined-format_each">format_each</a>, <a href="#args_add_joined-format_joined">format_joined</a>,
                <a href="#args_add_joined-join_with">join_with</a>, <a href="#args_add_joined-omit_if_empty">omit_if_empty</a>, <a href="#args_add_joined-omit_if_missing">omit_if_missing</a>, <a href="#args_add_joined-requires_any_of">requires_any_of</a>, <a href="#args_add_joined-uniquify">uniquify</a>, <a href="#args_add_joined-value">value</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="args_add_joined-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="args_add_joined-data"></a>data |  -   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="args_add_joined-actions"></a>actions |  See documentation for args macro wrapper.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="args_add_joined-arg_name"></a>arg_name |  -   | String | optional |  `""`  |
| <a id="args_add_joined-env"></a>env |  See documentation for args macro wrapper.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="args_add_joined-expand_directories"></a>expand_directories |  -   | Boolean | optional |  `False`  |
| <a id="args_add_joined-format_each"></a>format_each |  -   | String | optional |  `""`  |
| <a id="args_add_joined-format_joined"></a>format_joined |  -   | String | optional |  `""`  |
| <a id="args_add_joined-join_with"></a>join_with |  -   | String | required |  |
| <a id="args_add_joined-omit_if_empty"></a>omit_if_empty |  -   | Boolean | optional |  `True`  |
| <a id="args_add_joined-omit_if_missing"></a>omit_if_missing |  -   | Boolean | optional |  `False`  |
| <a id="args_add_joined-requires_any_of"></a>requires_any_of |  See documentation for args macro wrapper.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="args_add_joined-uniquify"></a>uniquify |  -   | Boolean | optional |  `False`  |
| <a id="args_add_joined-value"></a>value |  -   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |


<a id="args_add_strings"></a>

## args_add_strings

<pre>
load("@rules_toolchains//toolchains/private:documented_api.bzl", "args_add_strings")

args_add_strings(<a href="#args_add_strings-name">name</a>, <a href="#args_add_strings-data">data</a>, <a href="#args_add_strings-actions">actions</a>, <a href="#args_add_strings-env">env</a>, <a href="#args_add_strings-requires_any_of">requires_any_of</a>, <a href="#args_add_strings-values">values</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="args_add_strings-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="args_add_strings-data"></a>data |  -   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="args_add_strings-actions"></a>actions |  See documentation for args macro wrapper.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="args_add_strings-env"></a>env |  See documentation for args macro wrapper.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="args_add_strings-requires_any_of"></a>requires_any_of |  See documentation for args macro wrapper.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="args_add_strings-values"></a>values |  -   | List of strings | required |  |


<a id="args_list"></a>

## args_list

<pre>
load("@rules_toolchains//toolchains/private:documented_api.bzl", "args_list")

args_list(<a href="#args_list-name">name</a>, <a href="#args_list-args">args</a>)
</pre>

An ordered list of args.

This is a convenience rule to allow you to group a set of multiple `args` into a
single list. This particularly useful for toolchain behaviors that require different flags for
different actions.

Note: The order of the arguments in `args` is preserved to support order-sensitive flags.

Example usage:
```
load("@rules_toolchains//toolchains:args.bzl", "args")
load("@rules_toolchains//toolchains:args_list.bzl", "args_list")

args(
    name = "gc_sections",
    actions = [
        "@rules_toolchains//toolchains/actions:link_actions",
    ],
    args = ["-Wl,--gc-sections"],
)

args(
    name = "function_sections",
    actions = [
        "@rules_toolchains//toolchains/actions:compile_actions",
        "@rules_toolchains//toolchains/actions:link_actions",
    ],
    args = ["-ffunction-sections"],
)

args_list(
    name = "gc_functions",
    args = [
        ":function_sections",
        ":gc_sections",
    ],
)
```

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="args_list-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="args_list-args"></a>args |  (ordered) args to include in this list.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |


<a id="feature"></a>

## feature

<pre>
load("@rules_toolchains//toolchains/private:documented_api.bzl", "feature")

feature(<a href="#feature-name">name</a>, <a href="#feature-args">args</a>, <a href="#feature-feature_name">feature_name</a>, <a href="#feature-implies">implies</a>, <a href="#feature-mutually_exclusive">mutually_exclusive</a>, <a href="#feature-overrides">overrides</a>, <a href="#feature-requires_any_of">requires_any_of</a>)
</pre>

A dynamic set of toolchain flags that create a singular [feature](https://bazel.build/docs/cc-toolchain-config-reference#features) definition.

A feature is basically a dynamically toggleable [`args_list`](#args_list). There are a variety of
dependencies and compatibility requirements that must be satisfied to enable a
[`feature`](#feature). Once those conditions are met, the arguments in [`feature.args`](#feature-args)
are expanded and added to the command-line.

A feature may be enabled or disabled through the following mechanisms:
* Via command-line flags, or a `.bazelrc` file via the
  [`--features` flag](https://bazel.build/reference/command-line-reference#flag--features)
* Through inter-feature relationships (via [`feature.implies`](#feature-implies)) where one
  feature may implicitly enable another.
* Individual rules (e.g. `cc_library`) or `package` definitions may elect to manually enable or
  disable features through the
  [`features` attribute](https://bazel.build/reference/be/common-definitions#common.features).

Note that a feature may alternate between enabled and disabled dynamically over the course of a
build. Because of their toggleable nature, it's generally best to avoid adding arguments to a
`toolchain` as a [`feature`](#feature) unless strictly necessary. Instead, prefer to express arguments
via [`toolchain.args`](#toolchain-args) whenever possible.

You should use a [`feature`](#feature) when any of the following apply:
* You need the flags to be dynamically toggled over the course of a build.
* You want build files to be able to configure the flags in question. For example, a
  binary might specify `features = ["optimize_for_size"]` to create a small
  binary instead of optimizing for performance.
* You need to carry forward Starlark toolchain behaviors. If you're migrating a
  complex Starlark-based toolchain definition to these rules, many of the
  workflows and flags were likely based on features.

If you only need to configure flags via the Bazel command-line, instead
consider adding a
[`bool_flag`](https://github.com/bazelbuild/bazel-skylib/tree/main/doc/common_settings_doc.md#bool_flag)
paired with a [`config_setting`](https://bazel.build/reference/be/general#config_setting)
and then make your `args` rule `select` on the `config_setting`.

For more details about how Bazel handles features, see the official Bazel
documentation at
https://bazel.build/docs/cc-toolchain-config-reference#features.

Example:
```
load("@rules_toolchains//toolchains:feature.bzl", "feature")

# A feature that enables LTO, which may be incompatible when doing interop with various
# languages (e.g. rust, go), or may need to be disabled for particular `cc_binary` rules
# for various reasons.
feature(
    name = "lto",
    feature_name = "lto",
    args = [":lto_args"],
)
```

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="feature-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="feature-args"></a>args |  A list of `args` or [`args_list`](#args_list) labels that are expanded when this feature is enabled.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="feature-feature_name"></a>feature_name |  The name of the feature that this rule implements.<br><br>The feature name is a string that will be used in the `features` attribute of rules to enable them (eg. `cc_binary(..., features = ["opt"])`.<br><br>While two features with the same `feature_name` may not be bound to the same toolchain, they can happily live alongside each other in the same BUILD file.<br><br>Example: <pre><code>feature(&#10;    name = "sysroot_macos",&#10;    feature_name = "sysroot",&#10;    ...&#10;)&#10;&#10;feature(&#10;    name = "sysroot_linux",&#10;    feature_name = "sysroot",&#10;    ...&#10;)</code></pre>   | String | optional |  `""`  |
| <a id="feature-implies"></a>implies |  List of features enabled along with this feature.<br><br>Warning: If any of the features cannot be enabled, this feature is silently disabled.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="feature-mutually_exclusive"></a>mutually_exclusive |  A list of things that this feature is mutually exclusive with.<br><br>It can be either: * A feature, in which case the two features are mutually exclusive. * A [`mutually_exclusive_category`](#mutually_exclusive_category), in which case all features that write     `mutually_exclusive = [":category"]` are mutually exclusive with each other.<br><br>If this feature has a side-effect of implementing another feature, it can be useful to list that feature here to ensure they aren't enabled at the same time.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="feature-overrides"></a>overrides |  A declaration that this feature overrides a known feature.<br><br>In the example below, if you missed the "overrides" attribute, it would complain that the feature "opt" was defined twice.<br><br>Example: <pre><code>load("@rules_toolchains//toolchains:feature.bzl", "feature")&#10;&#10;feature(&#10;    name = "opt",&#10;    feature_name = "opt",&#10;    args = [":size_optimized"],&#10;    overrides = "@rules_toolchains//toolchains/features:opt",&#10;)</code></pre>   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="feature-requires_any_of"></a>requires_any_of |  A list of feature sets that define toolchain compatibility.<br><br>If *at least one* of the listed [`feature_set`](#feature_set)s are fully satisfied (all features exist in the toolchain AND are currently enabled), this feature is deemed compatible and may be enabled.<br><br>Note: Even if `feature.requires_any_of` is satisfied, a feature is not enabled unless another mechanism (e.g. command-line flags, `feature.implies`, `toolchain_config.enabled_features`) signals that the feature should actually be enabled.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |


<a id="feature_constraint"></a>

## feature_constraint

<pre>
load("@rules_toolchains//toolchains/private:documented_api.bzl", "feature_constraint")

feature_constraint(<a href="#feature_constraint-name">name</a>, <a href="#feature_constraint-all_of">all_of</a>, <a href="#feature_constraint-none_of">none_of</a>)
</pre>

Defines a compound relationship between features.

This rule can be used with [`args.require_any_of`](#args-require_any_of) to specify that a set
of arguments are only enabled when a constraint is met. Both `all_of` and `none_of` must be
satisfied simultaneously.

This is basically a [`feature_set`](#feature_set) that supports `none_of` expressions. This extra flexibility
is why this rule may only be used by [`args.require_any_of`](#args-require_any_of).

Example:
```
load("@rules_toolchains//toolchains:feature_constraint.bzl", "feature_constraint")

# A constraint that requires a `linker_supports_thinlto` feature to be enabled,
# AND a `no_optimization` to be disabled.
feature_constraint(
    name = "thinlto_constraint",
    all_of = [":linker_supports_thinlto"],
    none_of = [":no_optimization"],
)
```

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="feature_constraint-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="feature_constraint-all_of"></a>all_of |  -   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="feature_constraint-none_of"></a>none_of |  -   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |


<a id="feature_set"></a>

## feature_set

<pre>
load("@rules_toolchains//toolchains/private:documented_api.bzl", "feature_set")

feature_set(<a href="#feature_set-name">name</a>, <a href="#feature_set-all_of">all_of</a>)
</pre>

Defines a set of features.

This may be used by both [`feature`](#feature) and `args` rules, and is effectively a way to express
a logical `AND` operation across multiple required features.

Example:
```
load("@rules_toolchains//toolchains:feature_set.bzl", "feature_set")

feature_set(
    name = "thin_lto_requirements",
    all_of = [
        ":thin_lto",
        ":opt",
    ],
)
```

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="feature_set-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="feature_set-all_of"></a>all_of |  A set of features   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |


<a id="mutually_exclusive_category"></a>

## mutually_exclusive_category

<pre>
load("@rules_toolchains//toolchains/private:documented_api.bzl", "mutually_exclusive_category")

mutually_exclusive_category(<a href="#mutually_exclusive_category-name">name</a>)
</pre>

A rule used to categorize [`feature`](#feature) definitions for which only one can be enabled.

This is used by [`feature.mutually_exclusive`](#feature-mutually_exclusive) to express groups
of [`feature`](#feature) definitions that are inherently incompatible with each other and must be treated as
mutually exclusive.

Warning: These groups are keyed by name, so two [`mutually_exclusive_category`](#mutually_exclusive_category) definitions of the
same name in different packages will resolve to the same logical group.

Example:
```
load("@rules_toolchains//toolchains:feature.bzl", "feature")
load("@rules_toolchains//toolchains:mutually_exclusive_category.bzl", "mutually_exclusive_category")

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

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="mutually_exclusive_category-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |


<a id="string_list_variable"></a>

## string_list_variable

<pre>
load("@rules_toolchains//toolchains/private:documented_api.bzl", "string_list_variable")

string_list_variable(<a href="#string_list_variable-name">name</a>, <a href="#string_list_variable-actions">actions</a>, <a href="#string_list_variable-mandatory">mandatory</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="string_list_variable-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="string_list_variable-actions"></a>actions |  -   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="string_list_variable-mandatory"></a>mandatory |  -   | Boolean | required |  |


<a id="string_variable"></a>

## string_variable

<pre>
load("@rules_toolchains//toolchains/private:documented_api.bzl", "string_variable")

string_variable(<a href="#string_variable-name">name</a>, <a href="#string_variable-actions">actions</a>, <a href="#string_variable-mandatory">mandatory</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="string_variable-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="string_variable-actions"></a>actions |  -   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="string_variable-mandatory"></a>mandatory |  -   | Boolean | required |  |


<a id="tool"></a>

## tool

<pre>
load("@rules_toolchains//toolchains/private:documented_api.bzl", "tool")

tool(<a href="#tool-name">name</a>, <a href="#tool-src">src</a>, <a href="#tool-data">data</a>, <a href="#tool-capabilities">capabilities</a>, <a href="#tool-execution_requirements">execution_requirements</a>)
</pre>

Declares a tool for use by toolchain actions.

[`tool`](#tool) rules are used in a [`tool_map`](#tool_map) rule to ensure all files and
metadata required to run a tool are available when constructing a `toolchain`.

In general, include all files that are always required to run a tool (e.g. libexec/** and
cross-referenced tools in bin/*) in the [data](#tool-data) attribute. If some files are only
required when certain flags are passed to the tool, consider using a `args` rule to
bind the files to the flags that require them. This reduces the overhead required to properly
enumerate a sandbox with all the files required to run a tool, and ensures that there isn't
unintentional leakage across configurations and actions.

Example:
```
load("@rules_toolchains//toolchains:tool.bzl", "tool")

tool(
    name = "clang_tool",
    src = "@llvm_toolchain//:bin/clang",
    # Suppose clang needs libc to run.
    data = ["@llvm_toolchain//:lib/x86_64-linux-gnu/libc.so.6"]
    execution_requirements = {"requires-network": ""},
    capabilities = ["@rules_toolchains//toolchains/capabilities:supports_pic"],
)
```

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="tool-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="tool-src"></a>src |  The underlying binary that this tool represents.<br><br>Usually just a single prebuilt (eg. @toolchain//:bin/clang), but may be any executable label.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="tool-data"></a>data |  Additional files that are required for this tool to run.<br><br>Frequently, clang and gcc require additional files to execute as they often shell out to other binaries (e.g. `cc1`).   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="tool-capabilities"></a>capabilities |  Declares that a tool is capable of doing something.<br><br>For example, `@rules_cc@rules_toolchains//toolchains/capabilities:supports_pic`.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="tool-execution_requirements"></a>execution_requirements |  -   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |


<a id="tool_capability"></a>

## tool_capability

<pre>
load("@rules_toolchains//toolchains/private:documented_api.bzl", "tool_capability")

tool_capability(<a href="#tool_capability-name">name</a>, <a href="#tool_capability-feature_name">feature_name</a>)
</pre>

A capability is an optional feature that a tool supports.

For example, not all compilers support PIC, so to handle this, we write:

```
tool(
    name = "clang",
    src = "@host_tools/bin/clang",
    capabilities = [
        "@rules_toolchains//toolchains/capabilities:supports_pic",
    ],
)

args(
    name = "pic",
    requires = [
        "@rules_toolchains//toolchains/capabilities:supports_pic"
    ],
    args = ["-fPIC"],
)
```

This ensures that `-fPIC` is added to the command-line only when we are using a
tool that supports PIC.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="tool_capability-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="tool_capability-feature_name"></a>feature_name |  The name of the feature to generate for this capability   | String | optional |  `""`  |


<a id="toolchain_config"></a>

## toolchain_config

<pre>
load("@rules_toolchains//toolchains/private:documented_api.bzl", "toolchain_config")

toolchain_config(<a href="#toolchain_config-name">name</a>, <a href="#toolchain_config-default_features">default_features</a>, <a href="#toolchain_config-tool_map">tool_map</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="toolchain_config-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="toolchain_config-default_features"></a>default_features |  -   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="toolchain_config-tool_map"></a>tool_map |  -   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |


<a id="tool_map"></a>

## tool_map

<pre>
load("@rules_toolchains//toolchains/private:documented_api.bzl", "tool_map")

tool_map(<a href="#tool_map-name">name</a>, <a href="#tool_map-tools">tools</a>, <a href="#tool_map-kwargs">**kwargs</a>)
</pre>

A toolchain configuration rule that maps toolchain actions to tools.

A [`tool_map`](#tool_map) aggregates all the tools that may be used for a given toolchain
and maps them to their corresponding actions. Conceptually, this is similar to the
`CXX=/path/to/clang++` environment variables that most build systems use to determine which
tools to use for a given action. To simplify usage, some actions have been grouped together (for
example,
[@rules_cc@rules_toolchains//toolchains/actions:cpp_compile_actions](https://github.com/matts1/rules_toolchains/tree/main/toolchains/actions/BUILD)) to
logically express "all the C++ compile actions".

In Bazel, there is a little more granularity to the mapping, so the mapping doesn't follow the
traditional `CXX`, `AR`, etc. naming scheme. For a comprehensive list of all the well-known
actions, see @rules_toolchains//toolchains/actions:BUILD.

Example usage:
```
load("@rules_toolchains//toolchains:tool_map.bzl", "tool_map")

tool_map(
    name = "all_tools",
    tools = {
        "@rules_toolchains//toolchains/actions:assembly_actions": ":asm",
        "@rules_toolchains//toolchains/actions:c_compile": ":clang",
        "@rules_toolchains//toolchains/actions:cpp_compile_actions": ":clang++",
        "@rules_toolchains//toolchains/actions:link_actions": ":lld",
        "@rules_toolchains//toolchains/actions:objcopy_embed_data": ":llvm-objcopy",
        "@rules_toolchains//toolchains/actions:strip": ":llvm-strip",
        "@rules_toolchains//toolchains/actions:ar_actions": ":llvm-ar",
    },
)
```


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="tool_map-name"></a>name |  (str) The name of the target.   |  none |
| <a id="tool_map-tools"></a>tools |  (Dict[Label, Label]) A mapping between [`action_type`](#action_type)/[`action_type_set`](#action_type_set) targets and the [`tool`](#tool) or executable target that implements that action.   |  none |
| <a id="tool_map-kwargs"></a>kwargs |  [common attributes](https://bazel.build/reference/be/common-definitions#common-attributes) that should be applied to this rule.   |  none |


