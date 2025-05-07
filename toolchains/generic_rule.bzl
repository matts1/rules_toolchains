"""The API for creating generic rules based on running actions."""

load("//toolchains:toolchain_info.bzl", "ArgsListInfo", "FeatureInfo", "FeatureSetInfo")
load("//toolchains/private:action.bzl", "resolve_action_from_toolchain")
load("//toolchains/private:collect.bzl", "collect_args_lists")

visibility("public")

def run_action(
        ctx,
        *,
        toolchain_config,
        action_type,
        variables,
        extra_action_args = [],
        mnemonic = None,
        progress_message = None,
        enabled_features = None,
        disabled_features = None,
        extra_args = None,
        extra_inputs = [],
        extra_outputs = [],
        inputs_file = None):
    """Calls ctx.actions.run with the appropriate CLI based on toolchain config.

    Args:
        ctx: The ctx of the caller.
        toolchain_config: (ToolchainConfigInfo) The toolchain configuration.
        action_type: (ActionTypeInfo) The type of action to be executed.
        variables: (struct) A struct containing variables accessible to the
          args of an action. For example, `source_files` or `output_file`
        extra_action_args: (list[ctx.action.args]) Extra ctx.action.args to add
          to the action args.
        mnemonic: (Optional[str]) Overrides the mnemonic (defaults to action
          type's mnemonic).
        progress_message: (Optional[str]) The progress message to pass to the
          action
        enabled_features: (Optional[Sequence[FeatureInfo]]) Features that have
          been explicitly enabled for this action only.
        disabled_features: (Optional[Sequence[FeatureInfo]]) Features that have
          been explicitly disabled for this action only.
        extra_args: (Optional[Sequence[ArgsInfo]]) Additional args that have
          been explicitly added for this action only.
        extra_inputs: (Sequence[File]) Additional inputs to this action.
        extra_outputs: (Sequence[File]) Additional outputs to this action.
        inputs_file: (Optional[File]) If provided, this file will be filled
          with all inputs to this action.
    """
    if ctx.attr.features:
        fail("Features is a reserved attribute in bazel. Use the attributes `enabled_features` and `disabled_features` instead")
    if enabled_features == None:
        enabled_features = [target[FeatureInfo] for target in ctx.attr.enabled_features]
    if disabled_features == None:
        disabled_features = [target[FeatureInfo] for target in ctx.attr.disabled_features]
    if extra_args == None:
        extra_args = collect_args_lists(ctx.attr.extra_args)

    action = resolve_action_from_toolchain(
        toolchain = toolchain_config,
        action_type = action_type.label,
        extra_args = extra_args,
        enabled_features = enabled_features,
        disabled_features = disabled_features,
    )
    tool = toolchain_config.tool_map.configs[action_type.label]

    # This is a mutable struct that is given to each arg to modify.
    execution_ctx = struct(
        ctx = ctx,
        action_type = action_type,
        features = action.features,
        variables = variables,
        outputs = extra_outputs[:],
        env = {},
        inputs = extra_inputs[:],
        progress_message = progress_message,
        execution_requirements = tool.execution_requirements,
    )

    args = []
    for arg in action.args:
        args.append(ctx.actions.args())
        arg.fill(arg, execution_ctx, args[-1])

    args.extend(extra_action_args)
    inputs = depset(execution_ctx.inputs, transitive = [action.files])

    ctx.actions.run(
        outputs = execution_ctx.outputs,
        executable = tool.exe,
        mnemonic = mnemonic or action_type.mnemonic,
        progress_message = progress_message,
        arguments = args,
        env = execution_ctx.env,
        tools = tool.files_to_run,
        inputs = inputs,
        execution_requirements = execution_ctx.execution_requirements,
    )

    if inputs_file:
        out_args = []
        out_args.append(ctx.actions.args())
        out_args[-1].add(inputs_file)
        for arg in args:
            out_args.append(ctx.actions.args())
            out_args[-1].add("ARG_SPLITTER")
            out_args.append(arg)

        ctx.actions.run(
            outputs = [inputs_file],
            executable = ctx.executable._generate_inputs_file,
            mnemonic = "InputFile",
            arguments = out_args,
            env = {
                "ACTION": str(action_type.label),
                "ARGS": "\n".join([str(arg.label) for arg in action.args]),
                "ENV": json.encode(execution_ctx.env),
                "FEATURES": "\n".join([
                    str(ft.label)
                    for ft in action.features.values()
                ]),
                "OUTPUTS": "\n".join(sorted([output.path for output in execution_ctx.outputs])),
                "PROGRESS_MESSAGE": progress_message or "",
                "TOOL": str(tool.label),
                "TOOL_EXE": tool.exe.path,
                "EXECUTION_REQUIREMENTS": json.encode(execution_ctx.execution_requirements),
            },
            tools = tool.files_to_run,
            inputs = inputs,
            execution_requirements = execution_ctx.execution_requirements,
        )

# Recommended attributes for every rule.
GENERIC_RULE_ATTRS = {
    "extra_args": attr.label_list(providers = [ArgsListInfo]),
    "enabled_features": attr.label_list(providers = [FeatureSetInfo]),
    "disabled_features": attr.label_list(providers = [FeatureSetInfo]),
    "_generate_inputs_file": attr.label(executable = True, cfg = "exec", default = "@rules_toolchains//debug:generate_inputs_file"),
}
