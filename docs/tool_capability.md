<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Implementation of the tool_capability rule.

<a id="tool_capability"></a>

## tool_capability

<pre>
load("@rules_toolchains//toolchains:tool_capability.bzl", "tool_capability")

tool_capability(<a href="#tool_capability-name">name</a>, <a href="#tool_capability-feature_name">feature_name</a>)
</pre>

A capability is an optional feature that a tool supports.

For example, not all compilers support PIC, so to handle this, we write:

```
tool(
    name = "clang",
    src = "@host_tools/bin/clang",
    capabilities = [
        "//toolchains/capabilities:supports_pic",
    ],
)

args(
    name = "pic",
    requires = [
        "//toolchains/capabilities:supports_pic"
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


