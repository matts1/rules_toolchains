load("//toolchains:toolchain_info.bzl", "FeatureConstraintInfo")

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
        validate_requires(requirer=ft.label, features=features, constraints=ft.requires)

        for category in ft.mutually_exclusive:
            if category.label in features:
                fail("%s and %s are mutually exclusive" % (ft.label, category.label))

            if category.label in categories:
                fail("%s and %s are mutually exclusive (due to the category %s)" % (categories[category.label], ft.label, category.label))
            categories[category.label] = ft.label

def create_constraint(*, label, all_of, any_of, none_of):
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
    for constraint in constraints:
        err = constraint.validate(constraint, features)
        if err != None:
            fail("%s requires %s.\n%s" % (requirer, constraint.label, err))
    return None
