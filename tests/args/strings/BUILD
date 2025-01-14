load("@aspect_bazel_lib//lib:write_source_files.bzl", "write_source_files")
load("@rules_toolchains//toolchains:args.bzl", "args_add_strings")
load("@rules_toolchains//toolchains:feature.bzl", "feature")
load("//tests/rules:rules.bzl", "run_action_test")

args_add_strings(
    name = "strings",
    actions = ["//tests/toolchain/actions:compile"],
    data = ["testdata/foo"],
    env = {
        "STRING1": "S1",
        "STRING2": "S2",
    },
    values = [
        "string1",
        "string2",
    ],
)

# TODO: requires

run_action_test(
    name = "args_add_strings_test",
    action = "//tests/toolchain/actions:compile",
    extra_args = [":strings"],
)

run_action_test(
    name = "wrong_action_type_test",
    action = "//tests/toolchain/actions:link",
    extra_args = [":strings"],
)

feature(
    name = "strings_feature",
    args = [":strings"],
)

run_action_test(
    name = "feature_with_args_test",
    action = "//tests/toolchain/actions:compile",
    enabled_features = [":strings_feature"],
)

# TODO: rule finalizer
write_source_files(
    name = "update_goldens",
    additional_update_targets = [
        ":args_add_strings",
        ":wrong_action_type",
        ":feature_with_args",
    ],
    visibility = ["//tests:__pkg__"],
)
