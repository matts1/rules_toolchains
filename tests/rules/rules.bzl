"""Rules for testing rules_toolchains"""

load("@aspect_bazel_lib//lib:write_source_files.bzl", "write_source_file")
load("@rules_testing//lib:analysis_test.bzl", "analysis_test")
load("@rules_testing//lib:truth.bzl", "matching")
load("@rules_testing//lib:util.bzl", "util")
load("@rules_toolchains//toolchains:generic_rule.bzl", "GENERIC_RULE_ATTRS", "run_action")
load("@rules_toolchains//toolchains:toolchain_info.bzl", "ActionTypeInfo")

visibility("//tests/...")

_TOOLCHAIN_TYPE = "//tests/toolchain:toolchain_type"

def _run_action_impl(ctx):
    if ctx.attr.features:
        fail("Features is a reserved attribute in bazel. Use the attributes `enabled_features` and `disabled_features` instead")

    toolchain = ctx.toolchains[_TOOLCHAIN_TYPE].config

    output_file = ctx.actions.declare_file(ctx.label.name + ".output")
    input_files = ctx.files.testdata

    variables = struct(
        string = "mandatory_string_value",
        input_file = input_files[0],
        none = None,
        empty = [],
        strings = ["mfirst", "msecond"],
        input_files = input_files,
    )

    inputs_file = ctx.actions.declare_file(ctx.label.name + ".inputs")
    run_action(
        ctx,
        toolchain_config = toolchain,
        extra_outputs = [output_file],
        action_type = ctx.attr.action[ActionTypeInfo],
        variables = variables,
        inputs_file = inputs_file,
    )

    return [
        DefaultInfo(files = depset([inputs_file])),
    ]

_run_action = rule(
    implementation = _run_action_impl,
    attrs = {
        "testdata": attr.label(default = "//tests/rules:testdata"),
        "action": attr.label(mandatory = True, providers = [ActionTypeInfo]),
    } | GENERIC_RULE_ATTRS,
    toolchains = [_TOOLCHAIN_TYPE],
)

def run_action_test(name, **kwargs):
    """Runs an action, and validates it against a golden file.

    Args:
        name: (str) The name of the test
        **kwargs: The kwargs to pass to run_action
    """
    if not name.endswith("_test"):
        fail("Test name must end with test - got %s" % name)
    basename = name[:-5]
    action_name = "_%s_subject" % basename
    _run_action(name = action_name, **kwargs)

    write_source_file(
        name = basename,
        in_file = action_name,
        out_file = "golden/%s.inputs" % basename,
        suggested_update_target = "//tests:update_goldens",
    )

def error_matching(want_error):
    """Matches an error against an error

    Args:
        want_error: (str) The expected error

    Returns:
        An implementation suitable for an analysis_test
    """

    def impl(env, target):
        env.expect.that_target(target).failures().contains_predicate(matching.contains(want_error))

    return impl

def failing_action_test(name, want_error, **kwargs):
    """Tests that an action fails.

    Args:
        name: (string) Name of the test
        want_error: (string) The expected error message.
        **kwargs: (Any) Kwargs to pass to run_action.
    """
    if not name.endswith("_test"):
        fail("Test name must end with test - got %s" % name)
    basename = name[:-5]
    action_name = "_%s_subject" % basename
    util.helper_target(_run_action, name = action_name, **kwargs)

    analysis_test(
        name = name,
        expect_failure = True,
        impl = error_matching(want_error),
        target = action_name,
    )
