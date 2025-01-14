<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Implementation of the feature_set rule.

<a id="feature_set"></a>

## feature_set

<pre>
load("@rules_toolchains//toolchains:feature_set.bzl", "feature_set")

feature_set(<a href="#feature_set-name">name</a>, <a href="#feature_set-all_of">all_of</a>)
</pre>

Defines a set of features.

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

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="feature_set-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="feature_set-all_of"></a>all_of |  A set of features   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |


