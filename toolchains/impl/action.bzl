load("//toolchains:toolchain_info.bzl", "FeatureInfo", "ArgsListInfo")
load("//toolchains/private:collect.bzl", "collect_provider")
load(":features.bzl", "validate_requires", "get_features_from_toolchain")

visibility("//...")

def resolve_action(*, args, action_type, features, extra_args):
    args = list(args)
    for feature in features.values():
        args.extend(feature.args)
    args.extend(extra_args)

    args = [arg for arg in args if action_type in arg.actions]

    for arg in args:
        validate_requires(features, arg.label, arg.requires)

    return struct(
        action_type = action_type,
        features = features,
        args = args,
        files = depset(transitive = [arg.files for arg in args]),
    )

def resolve_action_from_toolchain(*, toolchain, action_type, extra_args, enabled_features, disabled_features):
    if not extra_args and not enabled_features and not disabled_features:
        return toolchain.defaults_by_action[action_type]
    features = get_features_from_toolchain(
        toolchain = toolchain,
        action_type = action_type,
        enabled_features = enabled_features,
        disabled_features = disabled_features
    )
    tool = toolchain.tool_map.config[action_type]
    return resolve_action(args = tool.args + toolchain.args, action_type = action_type, features =features, extra_args = extra_args)
