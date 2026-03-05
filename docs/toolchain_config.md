<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Implementation of the toolchain rule.

<a id="toolchain_config"></a>

## toolchain_config

<pre>
load("@rules_toolchains//toolchains:toolchain_config.bzl", "toolchain_config")

toolchain_config(<a href="#toolchain_config-name">name</a>, <a href="#toolchain_config-default_features">default_features</a>, <a href="#toolchain_config-tool_map">tool_map</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="toolchain_config-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="toolchain_config-default_features"></a>default_features |  -   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="toolchain_config-tool_map"></a>tool_map |  -   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |


