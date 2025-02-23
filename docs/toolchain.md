<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Implementation of the toolchain rule.

<a id="toolchain"></a>

## toolchain

<pre>
load("@rules_toolchains//toolchains:toolchain.bzl", "toolchain")

toolchain(<a href="#toolchain-name">name</a>, <a href="#toolchain-default_features">default_features</a>, <a href="#toolchain-tool_map">tool_map</a>, <a href="#toolchain-toolchain_type">toolchain_type</a>, <a href="#toolchain-exec_platforms">exec_platforms</a>)
</pre>

Toolchain for a given toolchain type.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="toolchain-name"></a>name |  (str) The prefix given to all toolchains. This will create one toolchain target per exec platform.   |  none |
| <a id="toolchain-default_features"></a>default_features |  (List[Label]) A list of labels corresponding to features that are enabled by default.   |  none |
| <a id="toolchain-tool_map"></a>tool_map |  (Label) A tool map created by the `tool_map` rule.   |  none |
| <a id="toolchain-toolchain_type"></a>toolchain_type |  (Label) The type of toolchain this corresponds to.   |  none |
| <a id="toolchain-exec_platforms"></a>exec_platforms |  (Dict[Label, List[Label]]) A mapping from execution platform that this toolchain could run on to its requirements.   |  `None` |


