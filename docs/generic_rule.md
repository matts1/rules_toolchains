<!-- Generated with Stardoc: http://skydoc.bazel.build -->

The API for creating generic rules based on running actions.

<a id="run_action"></a>

## run_action

<pre>
load("@rules_toolchains//toolchains:generic_rule.bzl", "run_action")

run_action(<a href="#run_action-ctx">ctx</a>, *, <a href="#run_action-toolchain_config">toolchain_config</a>, <a href="#run_action-action_type">action_type</a>, <a href="#run_action-variables">variables</a>, <a href="#run_action-extra_action_args">extra_action_args</a>, <a href="#run_action-mnemonic">mnemonic</a>,
           <a href="#run_action-progress_message">progress_message</a>, <a href="#run_action-enabled_features">enabled_features</a>, <a href="#run_action-disabled_features">disabled_features</a>, <a href="#run_action-extra_args">extra_args</a>, <a href="#run_action-extra_inputs">extra_inputs</a>,
           <a href="#run_action-extra_outputs">extra_outputs</a>, <a href="#run_action-exec_group">exec_group</a>, <a href="#run_action-resource_set">resource_set</a>, <a href="#run_action-toolchain_type">toolchain_type</a>, <a href="#run_action-inputs_file">inputs_file</a>)
</pre>

Calls ctx.actions.run with the appropriate CLI based on toolchain config.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="run_action-ctx"></a>ctx |  The ctx of the caller.   |  none |
| <a id="run_action-toolchain_config"></a>toolchain_config |  (ToolchainConfigInfo) The toolchain configuration.   |  none |
| <a id="run_action-action_type"></a>action_type |  (ActionTypeInfo) The type of action to be executed.   |  none |
| <a id="run_action-variables"></a>variables |  (struct) A struct containing variables accessible to the args of an action. For example, `source_files` or `output_file`   |  none |
| <a id="run_action-extra_action_args"></a>extra_action_args |  (list[ctx.action.args]) Extra ctx.action.args to add to the action args.   |  `[]` |
| <a id="run_action-mnemonic"></a>mnemonic |  (Optional[str]) Overrides the mnemonic (defaults to action type's mnemonic).   |  `None` |
| <a id="run_action-progress_message"></a>progress_message |  (Optional[str]) The progress message to pass to the action   |  `None` |
| <a id="run_action-enabled_features"></a>enabled_features |  (Optional[Sequence[FeatureInfo]]) Features that have been explicitly enabled for this action only.   |  `None` |
| <a id="run_action-disabled_features"></a>disabled_features |  (Optional[Sequence[FeatureInfo]]) Features that have been explicitly disabled for this action only.   |  `None` |
| <a id="run_action-extra_args"></a>extra_args |  (Optional[Sequence[ArgsInfo]]) Additional args that have been explicitly added for this action only.   |  `None` |
| <a id="run_action-extra_inputs"></a>extra_inputs |  (Sequence[File]) Additional inputs to this action.   |  `[]` |
| <a id="run_action-extra_outputs"></a>extra_outputs |  (Sequence[File]) Additional outputs to this action.   |  `[]` |
| <a id="run_action-exec_group"></a>exec_group |  (Optional[string]) Passed through to ctx.actions.run   |  `None` |
| <a id="run_action-resource_set"></a>resource_set |  (Optional[Callback]) Passed through to ctx.actions.run   |  `None` |
| <a id="run_action-toolchain_type"></a>toolchain_type |  (Optional[Label]) Passed through to ctx.actions.run(toolchain = toolchain_type)   |  `None` |
| <a id="run_action-inputs_file"></a>inputs_file |  (Optional[File]) If provided, this file will be filled with all inputs to this action.   |  `None` |


