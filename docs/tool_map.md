<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Implementation of tool_map.

<a id="tool_map"></a>

## tool_map

<pre>
load("@rules_toolchains//toolchains:tool_map.bzl", "tool_map")

tool_map(<a href="#tool_map-name">name</a>, <a href="#tool_map-tools">tools</a>, <a href="#tool_map-kwargs">**kwargs</a>)
</pre>

A toolchain configuration rule that maps toolchain actions to tools.

A `tool_map` aggregates all the tools that may be used for a given toolchain
and maps them to their corresponding actions. Conceptually, this is similar to the
`CXX=/path/to/clang++` environment variables that most build systems use to determine which
tools to use for a given action. To simplify usage, some actions have been grouped together (for
example,
[@rules_cc//toolchains/actions:cpp_compile_actions](https://github.com/matts1/rules_toolchains/tree/main/toolchains/actions/BUILD)) to
logically express "all the C++ compile actions".

Example usage:
```
load("//toolchains:tool_map.bzl", "tool_map")

tool_map(
    name = "all_tools",
    tools = {
        "//toolchains/actions:assembly_actions": ":asm",
        "//toolchains/actions:c_compile": ":clang",
        "//toolchains/actions:cpp_compile_actions": ":clang++",
        "//toolchains/actions:link_actions": ":lld",
        "//toolchains/actions:objcopy_embed_data": ":llvm-objcopy",
        "//toolchains/actions:strip": ":llvm-strip",
        "//toolchains/actions:ar_actions": ":llvm-ar",
    },
)
```


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="tool_map-name"></a>name |  (str) The name of the target.   |  none |
| <a id="tool_map-tools"></a>tools |  (Dict[Label, Label]) A mapping between `action_type`/`action_type_set` targets and the `tool` or executable target that implements that action.   |  none |
| <a id="tool_map-kwargs"></a>kwargs |  [common attributes](https://bazel.build/reference/be/common-definitions#common-attributes) that should be applied to this rule.   |  none |


