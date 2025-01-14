<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Rules to turn action types into bazel labels.

<a id="action_type"></a>

## action_type

<pre>
load("@rules_toolchains//toolchains:actions.bzl", "action_type")

action_type(<a href="#action_type-name">name</a>, <a href="#action_type-mnemonic">mnemonic</a>)
</pre>

A type of action (eg. c_compile, assemble, strip).

`action_type` rules are used to associate arguments and tools together to
perform a specific action. Bazel prescribes a set of known action types that are used to drive
typical C/C++/ObjC actions like compiling, linking, and archiving. The set of well-known action
types can be found in [@rules_cc//toolchains/actions:BUILD](https://github.com/matts1/rules_toolchains/tree/main/toolchains/actions/BUILD).

It's possible to create project-specific action types for use in toolchains. Be careful when
doing this, because every toolchain that encounters the action will need to be configured to
support the custom action type. If your project is a library, avoid creating new action types as
it will reduce compatibility with existing toolchains and increase setup complexity for users.

Example:
```
load("//toolchains:actions.bzl", "action_type")

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
load("@rules_toolchains//toolchains:actions.bzl", "action_type_set")

action_type_set(<a href="#action_type_set-name">name</a>, <a href="#action_type_set-actions">actions</a>, <a href="#action_type_set-allow_empty">allow_empty</a>)
</pre>

Represents a set of actions.

This is a convenience rule to allow for more compact representation of a group of action types.
Use this anywhere a `action_type` is accepted.

Example:
```
load("//toolchains:actions.bzl", "action_type_set")

action_type_set(
    name = "link_executable_actions",
    actions = [
        "//toolchains/actions:cpp_link_executable",
        "//toolchains/actions:lto_index_for_executable",
    ],
)
```

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="action_type_set-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="action_type_set-actions"></a>actions |  A list of action_type or action_type_set   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="action_type_set-allow_empty"></a>allow_empty |  -   | Boolean | optional |  `False`  |


