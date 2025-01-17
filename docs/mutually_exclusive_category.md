<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Rule for mutually exclusive categories in the rule based toolchain.

<a id="mutually_exclusive_category"></a>

## mutually_exclusive_category

<pre>
load("@rules_toolchains//toolchains:mutually_exclusive_category.bzl", "mutually_exclusive_category")

mutually_exclusive_category(<a href="#mutually_exclusive_category-name">name</a>)
</pre>

A rule used to categorize `feature` definitions for which only one can be enabled.

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

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="mutually_exclusive_category-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |


