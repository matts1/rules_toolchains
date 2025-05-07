<!-- Generated with Stardoc: http://skydoc.bazel.build -->

All providers for rule-based bazel toolchain config.

<a id="ActionTypeInfo"></a>

## ActionTypeInfo

<pre>
load("@rules_toolchains//toolchains:toolchain_info.bzl", "ActionTypeInfo")

ActionTypeInfo(<a href="#ActionTypeInfo-label">label</a>, <a href="#ActionTypeInfo-mnemonic">mnemonic</a>)
</pre>

A type of action (eg. c-compile, c++-link-executable)

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="ActionTypeInfo-label"></a>label |  (Label) The label defining this provider. Place in error messages to simplify debugging    |
| <a id="ActionTypeInfo-mnemonic"></a>mnemonic |  (string) The mnemonic to use for this action    |


<a id="ActionTypeSetInfo"></a>

## ActionTypeSetInfo

<pre>
load("@rules_toolchains//toolchains:toolchain_info.bzl", "ActionTypeSetInfo")

ActionTypeSetInfo(<a href="#ActionTypeSetInfo-label">label</a>, <a href="#ActionTypeSetInfo-actions">actions</a>)
</pre>

A set of types of actions

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="ActionTypeSetInfo-label"></a>label |  (Label) The label defining this provider. Place in error messages to simplify debugging    |
| <a id="ActionTypeSetInfo-actions"></a>actions |  (depset[ActionTypeInfo]) Set of action types    |


<a id="ArgsInfo"></a>

## ArgsInfo

<pre>
load("@rules_toolchains//toolchains:toolchain_info.bzl", "ArgsInfo")

ArgsInfo(<a href="#ArgsInfo-label">label</a>, <a href="#ArgsInfo-actions">actions</a>, <a href="#ArgsInfo-requires">requires</a>, <a href="#ArgsInfo-files">files</a>, <a href="#ArgsInfo-env">env</a>, <a href="#ArgsInfo-fill">fill</a>, <a href="#ArgsInfo-storage">storage</a>)
</pre>

A set of arguments to be added to the command line for specific actions

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="ArgsInfo-label"></a>label |  (Label) The label defining this provider. Place in error messages to simplify debugging    |
| <a id="ArgsInfo-actions"></a>actions |  (Sequence[Label]]) The set of actions this is associated with    |
| <a id="ArgsInfo-requires"></a>requires |  (Sequence[FeatureConstraintInfo]) This will be skipped if none of the listed predicates are met.    |
| <a id="ArgsInfo-files"></a>files |  (depset[File]) Files required for the args    |
| <a id="ArgsInfo-env"></a>env |  (dict[str, str]) Environment variables to apply    |
| <a id="ArgsInfo-fill"></a>fill |  (Function(self, execution_ctx, ctx.action.Args)) The mechanism to resolve the args to something that actually runs on the command line.    |
| <a id="ArgsInfo-storage"></a>storage |  (any) Storage for arbitrary data to be used by the fill function    |


<a id="ArgsListInfo"></a>

## ArgsListInfo

<pre>
load("@rules_toolchains//toolchains:toolchain_info.bzl", "ArgsListInfo")

ArgsListInfo(<a href="#ArgsListInfo-label">label</a>, <a href="#ArgsListInfo-args">args</a>)
</pre>

A ordered list of arguments

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="ArgsListInfo-label"></a>label |  (Label) The label defining this provider. Place in error messages to simplify debugging    |
| <a id="ArgsListInfo-args"></a>args |  (Sequence[ArgsInfo]) The flag sets contained within    |


<a id="FeatureConstraintInfo"></a>

## FeatureConstraintInfo

<pre>
load("@rules_toolchains//toolchains:toolchain_info.bzl", "FeatureConstraintInfo")

FeatureConstraintInfo(<a href="#FeatureConstraintInfo-label">label</a>, <a href="#FeatureConstraintInfo-storage">storage</a>, <a href="#FeatureConstraintInfo-validate">validate</a>)
</pre>

A predicate checking that certain features are enabled and others disabled.

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="FeatureConstraintInfo-label"></a>label |  (Label) The label defining this provider. Place in error messages to simplify debugging    |
| <a id="FeatureConstraintInfo-storage"></a>storage |  (any) Storage accessible by the validate function    |
| <a id="FeatureConstraintInfo-validate"></a>validate |  (Function(self, features) -> error) A function that validates that the constraint is met. Returns a string containing an error message, or None on success    |


<a id="FeatureInfo"></a>

## FeatureInfo

<pre>
load("@rules_toolchains//toolchains:toolchain_info.bzl", "FeatureInfo")

FeatureInfo(<a href="#FeatureInfo-label">label</a>, <a href="#FeatureInfo-args">args</a>, <a href="#FeatureInfo-implies">implies</a>, <a href="#FeatureInfo-requires">requires</a>, <a href="#FeatureInfo-mutually_exclusive">mutually_exclusive</a>, <a href="#FeatureInfo-late_validate">late_validate</a>)
</pre>

Contains all flag specifications for one feature.

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="FeatureInfo-label"></a>label |  (Label) The label defining this provider. Place in error messages to simplify debugging    |
| <a id="FeatureInfo-args"></a>args |  (Sequence[ArgsInfo]) Args enabled by this feature    |
| <a id="FeatureInfo-implies"></a>implies |  (Sequence[FeatureInfo]) Set of features implied by this feature    |
| <a id="FeatureInfo-requires"></a>requires |  (SmallSet[FeatureConstraintInfo]) A list of feature constraints, at least one of which is required to enable this feature. This is semantically equivalent to the requires attribute of rules_cc's FeatureInfo    |
| <a id="FeatureInfo-mutually_exclusive"></a>mutually_exclusive |  (Sequence[MutuallyExclusiveCategoryInfo]) Indicates that this feature is one of several mutually exclusive alternate features.    |
| <a id="FeatureInfo-late_validate"></a>late_validate |  (bool) Whether the feature is should be validated late    |


<a id="FeatureSetInfo"></a>

## FeatureSetInfo

<pre>
load("@rules_toolchains//toolchains:toolchain_info.bzl", "FeatureSetInfo")

FeatureSetInfo(<a href="#FeatureSetInfo-label">label</a>, <a href="#FeatureSetInfo-features">features</a>)
</pre>

A set of features

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="FeatureSetInfo-label"></a>label |  (Label) The label defining this provider. Place in error messages to simplify debugging    |
| <a id="FeatureSetInfo-features"></a>features |  (depset[FeatureInfo]) The set of features this corresponds to    |


<a id="ListVariableInfo"></a>

## ListVariableInfo

<pre>
load("@rules_toolchains//toolchains:toolchain_info.bzl", "ListVariableInfo")

ListVariableInfo(<a href="#ListVariableInfo-label">label</a>, <a href="#ListVariableInfo-name">name</a>, <a href="#ListVariableInfo-actions">actions</a>, <a href="#ListVariableInfo-type">type</a>)
</pre>

A variable defined by the toolchain

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="ListVariableInfo-label"></a>label |  (Label) The label defining this provider. Place in error messages to simplify debugging    |
| <a id="ListVariableInfo-name"></a>name |  (string) The name of the variable    |
| <a id="ListVariableInfo-actions"></a>actions |  (Sequence[Label]) The actions this variable is available for    |
| <a id="ListVariableInfo-type"></a>type |  A type as defined at the top of this file    |


<a id="MutuallyExclusiveCategoryInfo"></a>

## MutuallyExclusiveCategoryInfo

<pre>
load("@rules_toolchains//toolchains:toolchain_info.bzl", "MutuallyExclusiveCategoryInfo")

MutuallyExclusiveCategoryInfo(<a href="#MutuallyExclusiveCategoryInfo-label">label</a>)
</pre>

Multiple features with the category will be mutally exclusive

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="MutuallyExclusiveCategoryInfo-label"></a>label |  (Label) The label defining this provider. Place in error messages to simplify debugging    |


<a id="SingleVariableInfo"></a>

## SingleVariableInfo

<pre>
load("@rules_toolchains//toolchains:toolchain_info.bzl", "SingleVariableInfo")

SingleVariableInfo(<a href="#SingleVariableInfo-label">label</a>, <a href="#SingleVariableInfo-name">name</a>, <a href="#SingleVariableInfo-actions">actions</a>, <a href="#SingleVariableInfo-type">type</a>, <a href="#SingleVariableInfo-mandatory">mandatory</a>)
</pre>

A variable defined by the toolchain

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="SingleVariableInfo-label"></a>label |  (Label) The label defining this provider. Place in error messages to simplify debugging    |
| <a id="SingleVariableInfo-name"></a>name |  (string) The name of the variable    |
| <a id="SingleVariableInfo-actions"></a>actions |  (Sequence[Label]) The actions this variable is available for    |
| <a id="SingleVariableInfo-type"></a>type |  A type as defined at the top of this file    |
| <a id="SingleVariableInfo-mandatory"></a>mandatory |  (bool) Whether this variable can be none    |


<a id="ToolCapabilityInfo"></a>

## ToolCapabilityInfo

<pre>
load("@rules_toolchains//toolchains:toolchain_info.bzl", "ToolCapabilityInfo")

ToolCapabilityInfo(<a href="#ToolCapabilityInfo-label">label</a>, <a href="#ToolCapabilityInfo-feature">feature</a>)
</pre>

A capability associated with a tool (eg. supports_pic).

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="ToolCapabilityInfo-label"></a>label |  (Label) The label defining this provider. Place in error messages to simplify debugging    |
| <a id="ToolCapabilityInfo-feature"></a>feature |  (FeatureInfo) The feature this capability defines    |


<a id="ToolInfo"></a>

## ToolInfo

<pre>
load("@rules_toolchains//toolchains:toolchain_info.bzl", "ToolInfo")

ToolInfo(<a href="#ToolInfo-label">label</a>, <a href="#ToolInfo-exe">exe</a>, <a href="#ToolInfo-files_to_run">files_to_run</a>, <a href="#ToolInfo-execution_requirements">execution_requirements</a>, <a href="#ToolInfo-capabilities">capabilities</a>)
</pre>

A binary, with additional metadata to make it useful for action configs.

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="ToolInfo-label"></a>label |  (Label) The label defining this provider. Place in error messages to simplify debugging    |
| <a id="ToolInfo-exe"></a>exe |  (File) The file corresponding to the tool    |
| <a id="ToolInfo-files_to_run"></a>files_to_run |  (list[Union[FilesToRunProvider, depset[File]]) The files needed to run the executable    |
| <a id="ToolInfo-execution_requirements"></a>execution_requirements |  (Sequence[str]) A set of execution requirements of the tool    |
| <a id="ToolInfo-capabilities"></a>capabilities |  (Sequence[ToolCapabilityInfo]) Capabilities supported by the tool.    |


<a id="ToolMapInfo"></a>

## ToolMapInfo

<pre>
load("@rules_toolchains//toolchains:toolchain_info.bzl", "ToolMapInfo")

ToolMapInfo(<a href="#ToolMapInfo-label">label</a>, <a href="#ToolMapInfo-configs">configs</a>)
</pre>

A mapping from action to tool

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="ToolMapInfo-label"></a>label |  (Label) The label defining this provider. Place in error messages to simplify debugging    |
| <a id="ToolMapInfo-configs"></a>configs |  (dict[Label, ToolInfo]) A mapping from action type to tool.    |


<a id="ToolchainConfigInfo"></a>

## ToolchainConfigInfo

<pre>
load("@rules_toolchains//toolchains:toolchain_info.bzl", "ToolchainConfigInfo")

ToolchainConfigInfo(<a href="#ToolchainConfigInfo-label">label</a>, <a href="#ToolchainConfigInfo-enabled_features">enabled_features</a>, <a href="#ToolchainConfigInfo-defaults_by_action">defaults_by_action</a>, <a href="#ToolchainConfigInfo-tool_map">tool_map</a>)
</pre>

The configuration for a toolchain

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="ToolchainConfigInfo-label"></a>label |  (Label) The label defining this provider. Place in error messages to simplify debugging    |
| <a id="ToolchainConfigInfo-enabled_features"></a>enabled_features |  (SmallSet[FeatureInfo]) The features That are explicitly enabled by default for this toolchain    |
| <a id="ToolchainConfigInfo-defaults_by_action"></a>defaults_by_action |  (dict[Label, struct]]) A mapping from action type to some defaults for that action type.    |
| <a id="ToolchainConfigInfo-tool_map"></a>tool_map |  (ToolMapInfo) A provider mapping toolchain action types to tools.    |


