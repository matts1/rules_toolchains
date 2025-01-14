"""Feature resolution for the toolchain config."""

load("//toolchains:toolchain_info.bzl", "FeatureConstraintInfo")

visibility("//...")

def get_features_from_toolchain(toolchain, action_type, enabled_features, disabled_features):
    """Calculates the enabled features based on the toolchain.

    Works the same as get_features, but is optimized for the use case where
    the user doesn't manually specify either enabled or disabled features.

    Args:
        toolchain: (ToolchainInfo) The toolchain to look in
        action_type: (ActionTypeInfo) The action type in use. This can affect
          tool capabilities, which are exposed as features.
        enabled_features: (Sequence[FeatureInfo]) Explicitly enabled features.
        disabled_features: (Sequence[FeatureInfo]) Explicitly disabled features.

    Returns:
        dict[Label, FeatureInfo] A map from feature label to enabled feature.
    """
    if not enabled_features and not disabled_features:
        return toolchain.defaults_by_action[action_type].features

    default_features = toolchain.enabled_features
    capabilities = toolchain.tool_map.configs[action_type].capabilities
    if capabilities:
        default_features = list(default_features) + [cap.feature for cap in capabilities]
    return get_features(default_features, enabled_features, disabled_features)

def get_features(default_features, enabled_features, disabled_features):
    """Calculates enabled features.

    Note that this relies upon dict ordering, as feature order affects args order.
    Ordering: [dfs(x) for x in default + enabled]

    Args:
        default_features: (Sequence[FeatureInfo]) The features enabled by default.
        enabled_features: (Sequence[FeatureInfo]) Explicitly enabled features.
        disabled_features: (Sequence[FeatureInfo]) Explicitly disabled features.

    Returns:
        dict[Label, FeatureInfo] A map from feature label to enabled feature.
    """
    default_features = {ft.label: ft for ft in default_features}
    enabled_features = {ft.label: ft for ft in enabled_features}
    disabled_features = {ft.label: None for ft in disabled_features}

    features = {}
    for ft in default_features.values():
        if ft.label not in disabled_features:
            dfs_implies(ft, features, disabled_features)
    for ft in enabled_features.values():
        if ft.label in disabled_features:
            fail("%s is marked as both an enabled feature and a disabled feature" % ft.label)
        dfs_implies(ft, features, disabled_features)
    validate_features(features)
    return features

def dfs_implies(ft, features, disabled_features):
    """Performs a dfs to enable all features implied by ft.

    Args:
        ft: (FeatureInfo) The feature to start DFSing from
        features: (dict[Label, FeatireInfo]) The currently enabled features
        disabled_features: (dict[Label, None]) The explicitly disabled features
    """

    if ft.label not in features:
        features[ft.label] = ft
    todo = [ft]
    for _ in range(1 << 30):
        if not todo:
            break
        current = todo.pop()
        for ft in current.implies:
            if ft.label in disabled_features:
                fail("%s is marked as disabled, but is implied by %s, which is enabled" % (ft.label, current.label))
            if ft.label not in features:
                features[ft.label] = ft
                todo.append(ft)

def validate_features(features):
    """Validates that a valid set of features has been enabled.

    Args:
        features: (dict[Label, featureInfo]) The currently enabled features
    """
    categories = {}
    for ft in features.values():
        validate_requires(requirer = ft.label, features = features, constraints = ft.requires)

        for category in ft.mutually_exclusive:
            if category.label in features:
                fail("%s and %s are mutually exclusive" % (ft.label, category.label))

            if category.label in categories:
                fail("%s and %s are mutually exclusive (due to the category %s)" % (categories[category.label], ft.label, category.label))
            categories[category.label] = ft.label

def create_constraint(*, label, all_of, any_of, none_of):
    """Creates a constraint matching some conditions of other constraints.

    Args:
        label: (Label) The label of the constraint
        all_of: (Sequence[FeatureContsraintInfo]) All of these must be met to
          match this constraint.
        any_of: (Sequence[FeatureContsraintInfo]) Any of these must be met to
          match this constraint.
        none_of: (Sequence[FeatureContsraintInfo]) None of these must be met to
          match this constraint.

    Returns:
        A FeatureConstraintInfo
    """

    def validate(self, features):
        for constraint in self.storage.all_of:
            err = constraint.validate(constraint, features)
            if err != None:
                return "%s is unmet because %s" % (self.label, err)

        for constraint in self.storage.none_of:
            err = constraint.validate(constraint, features)
            if err == None:
                return "%s is unmet because %s is met" % (self.label, constraint.label)

        errors = []
        for constraint in self.storage.any_of:
            err = constraint.validate(constraint, features)
            if err == None:
                return None
            errors.append(err)

        if not errors:
            return None
        return "%s is unmet because %s" % (self.label, " and ".join(["(%s)" % err for err in errors]))

    return FeatureConstraintInfo(
        label = label,
        storage = struct(
            all_of = all_of,
            any_of = any_of,
            none_of = none_of,
        ),
        validate = validate,
    )

def validate_requires(*, features, requirer, constraints):
    """Validates that a set of requirements are met.

    Args:
        features: (dict[Label, FeatireInfo]) The currently enabled features.
        requirer: (Label) The thing that needs certain constraints.
        constraints: (Sequence[FeatureConstraintInfo]) Constraints that need to be met
    """
    for constraint in constraints:
        err = constraint.validate(constraint, features)
        if err != None:
            fail("%s requires %s.\n%s" % (requirer, constraint.label, err))
