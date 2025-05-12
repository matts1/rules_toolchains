<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Implementation of tool

<a id="tool"></a>

## tool

<pre>
load("@rules_toolchains//toolchains:tool.bzl", "tool")

tool(<a href="#tool-name">name</a>, <a href="#tool-src">src</a>, <a href="#tool-data">data</a>, <a href="#tool-capabilities">capabilities</a>, <a href="#tool-execution_requirements">execution_requirements</a>)
</pre>

Declares a tool for use by toolchain actions.

`tool` rules are used in a `tool_map` rule to ensure all files and
metadata required to run a tool are available when constructing a `toolchain`.

In general, include all files that are always required to run a tool (e.g. libexec/** and
cross-referenced tools in bin/*) in the [data](#tool-data) attribute. If some files are only
required when certain flags are passed to the tool, consider using a `args` rule to
bind the files to the flags that require them. This reduces the overhead required to properly
enumerate a sandbox with all the files required to run a tool, and ensures that there isn't
unintentional leakage across configurations and actions.

Example:
```
load("//toolchains:tool.bzl", "tool")

tool(
    name = "clang_tool",
    src = "@llvm_toolchain//:bin/clang",
    # Suppose clang needs libc to run.
    data = ["@llvm_toolchain//:lib/x86_64-linux-gnu/libc.so.6"]
    execution_requirements = {"requires-network": ""},
    capabilities = ["//toolchains/capabilities:supports_pic"],
)
```

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="tool-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="tool-src"></a>src |  The underlying binary that this tool represents.<br><br>Usually just a single prebuilt (eg. @toolchain//:bin/clang), but may be any executable label.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="tool-data"></a>data |  Additional files that are required for this tool to run.<br><br>Frequently, clang and gcc require additional files to execute as they often shell out to other binaries (e.g. `cc1`).   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="tool-capabilities"></a>capabilities |  Declares that a tool is capable of doing something.<br><br>For example, `@rules_cc//toolchains/capabilities:supports_pic`.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="tool-execution_requirements"></a>execution_requirements |  -   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |


