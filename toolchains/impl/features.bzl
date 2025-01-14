visibility("//...")

def get_features_from_toolchain(toolchain, action_type, enabled_features, disabled_features):
    if not enabled_features and not disabled_features:
        return toolchain.defaults_by_action[action_type].features

    default_features = toolchain.enabled_features
    capabilities = toolchain.tool_map.configs[action_type].capabilities
    if capabilities:
        default_features = list(default_features) + [cap.feature for cap in capabilities]
    return get_features(default_features, enabled_features, disabled_features)

def get_features(default_features, enabled_features, disabled_features):
    # Ordering: [dfs_implies(x) for x in default + enabled]
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
    if ft.label not in features:
        features[ft.label] = ft
    todo = [ft]
    for _ in range(1<<30):
        if not todo:
            break
        current = todo.pop()
        for ft in current.implies:
            if ft.label in disabled_features:
                fail("%s is marked as disabled, but is implied by %s, which is enabled" % (ft.label, current.label))
            if ft.label not in features:
                features[ft.label] = ft
                todo.append(ft)
    
    return features

def validate_features(features):
    categories = {}
    for ft in features.values():
        validate_requires(features, ft.label, ft.requires)

        for category in ft.mutually_exclusive:
            if category.label in features:
                fail("%s and %s are mutually exclusive" % (ft.label, category.label))

            if category.label in categories:
                fail("%s and %s are mutually exclusive (due to the category %s)" % (categories[category.label], ft.label, category.label))
            categories[category.label] = ft.label

def validate_requires(features, cause, constraints):
    errors = [validate_constraint(features, constraint) for constraint in constraints]
    if constraints and None not in errors:
        fail("%s did not meet any of its requirements:\n  %s" % (cause, "\n  ".join(errors)))


def validate_constraint(features, constraint):
    for ft in constraint.all_of:
        if ft.label not in features:
            return "%s is unmet (%s needs to be enabled)" % (constraint.label, ft.label)
    for ft in constraint.none_of:
        if ft.label in features:
            return "%s is unmet (%s cannot be enabled)" % (constraint.label, ft.label)
