<!-- Generated with Stardoc: http://skydoc.bazel.build -->

All providers for rule-based bazel toolchain config.

<a id="args_list"></a>

## args_list

<pre>
load("@rules_toolchains//toolchains:args_list.bzl", "args_list")

args_list(<a href="#args_list-name">name</a>, <a href="#args_list-args">args</a>)
</pre>

An ordered list of args.

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

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="args_list-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="args_list-args"></a>args |  (ordered) args to include in this list.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |


