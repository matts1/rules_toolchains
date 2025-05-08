`rules_cc` implemented rule-based toolchains in 2024, and was the original inspiration for this design. However, the fact that the toolchain had to resolve to a struct in order to pass it to bazel gave it many inherent limitations. `rules_toolchains` builds upon that design, while improving on the things that can be improved by native starlark.

# Labels
We have made labels the unique identifier for various parts of the toolchain. This solves issues with `rules_cc` previously having to use strings, which aren't safe.

# Features
Native bazel features are an unneccesary thing of the past, and we highly discourage the use of them. Instead, we come up with our own concept of features, which serves the same purpose, and a simple mechanism to enable and disable them. This allows for a variety of things:
* You can reference features that the toolchain was not even aware of.
* Features are *extremely* simple now
* Enabling a feature on the command-line can be done via:
  * Create a `bool_flag`
  * select on that `bool_flag` to put it into `default_features`
* Features are now purely implemented in starlark, removing complexity from bazel itself
* We no longer need a concept of "known features" and "enabled features", as you can enable a feature without knowing it.

# Args
The concept of args remains similar to `rules_cc`. However, `rules_cc` has a very confusing concept of `args` and `nested_args`, which we remove in favor of a simplified approach. We accept that build files cannot (and should not) cover 100% of use cases of args, so instead we put a function in the `ArgsInfo` provider. This allows for very complex args ([example](https://github.com/bazelbuild/rules_cc/blob/2128347b4ee2024536016ee4a28b7d3a98260f46/cc/toolchains/args/libraries_to_link/BUILD#L26-L87)) to simply write a custom rule returning an `ArgsInfo` provider, and they can allow the function to do complex things such as read complex structured data, the currently enabled features, etc.

We have also changed our policy on args. In `rules_cc`, we recommended putting args on toolchains, and only using features for toggleable things. This was the right thing to do there, as a user could disable any feature, which was not desirable. However, that added additional complexity with respect to order of arguments. In `rules_toolchains`, we have removed the concept of args attached directly to the toolchain. This is because the downside referenced earlier doesn't apply here - you can only toggle a feature in `rules_toolchains` if you can reference the label for the feature, and thus we recommend using visibility on your feature to ensure that users cannot reference the label.

# Feature Constraints
Similar to args, we use functions to broaden the concept of a feature constraint. A `FeatureConstraintInfo` is essentially a `Function(current_features) -> error`, and thus can create arbitrary constraints.

We also changed `requires_any_of` to `requires`, which requires all instead of any. This is because it is probably more common to require all instead of any, and we can now achieve any via `feature_constraint.any_of`.

# Actions
The core API here is:
```py
run_action(
    toolchain_config = toolchain_config,
    action_type = <action type>,
    variables = struct(
        source_files = ctx.files.srcs.to_list(),
        output_file = output_file,
        string = "string",
        string_list = ["foo"],
    )
)
```

The toolchain config will then convert that into `ctx.actions.run` with the appropriate tool and command-line arguments.