"""Action resolution for the toolchain"""

load(":features.bzl", "get_features_from_toolchain", "validate_requires")

visibility("//toolchains/...")

def resolve_action(*, action_type, features, extra_args):
    """Calculates all information relevant to an action.

    Args:
        action_type: (ActionTypeInfo) The action type to look up
        features: (dict[Label, FeatureInfo]) The currently enabled features
        extra_args: (Sequence[ArgsInfo]) Any additional arguments to be added.

    Returns:
        struct(
            action_type: ActionTypeInfo,
            features: dict[Label, FeatureInfo],
            args: Sequence[ArgsInfo],
            files: depset[File]
        )
    """
    args = []
    for feature in features.values():
        args.extend(feature.args)
    args.extend(extra_args)

    args = [arg for arg in args if action_type in arg.actions]

    for arg in args:
        validate_requires(requirer = arg.label, features = features, constraints = arg.requires)

    return struct(
        action_type = action_type,
        features = features,
        args = args,
        files = depset(transitive = [arg.files for arg in args]),
    )

def resolve_action_from_toolchain(*, toolchain, action_type, enabled_features, disabled_features, extra_args):
    """Calculates all information relevant to an action based on the current toolchain.

    Args:
        toolchain: (ToolchainConfigInfo) The toolchain configuration.
        action_type: (ActionTypeInfo) The action type to look up
        enabled_features: (Sequence[FeatureInfo]) Explicitly enabled features
        disabled_features: (Sequence[FeatureInfo]) Explicitly disabled features
        extra_args: (Sequence[ArgsInfo]) Any additional arguments to be added.

    Returns:
        struct(
            action_type: ActionTypeInfo,
            features: dict[Label, FeatureInfo],
            args: Sequence[ArgsInfo],
            files: depset[File]
        )
    """

    if not extra_args and not enabled_features and not disabled_features:
        return toolchain.defaults_by_action[action_type]
    features = get_features_from_toolchain(
        toolchain = toolchain,
        action_type = action_type,
        enabled_features = enabled_features,
        disabled_features = disabled_features,
    )
    return resolve_action(action_type = action_type, features = features, extra_args = extra_args)
