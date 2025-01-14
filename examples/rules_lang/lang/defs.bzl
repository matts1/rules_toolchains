load("@rules_toolchains//toolchains:generic_rule.bzl", "GENERIC_RULE_ATTRS", "run_action")
load("@rules_toolchains//toolchains:toolchain_info.bzl", "ActionTypeInfo")
load(":providers.bzl", "LangInfo")

visibility("public")

_LANG_TOOLCHAIN_TYPE = "//lang/toolchain:toolchain_type"

def _compile(ctx):
    if ctx.attr.features:
        fail("Features is a reserved attribute in bazel. Use the attributes `enabled_features` and `disabled_features` instead")

    toolchain = ctx.toolchains[_LANG_TOOLCHAIN_TYPE].config

    output = ctx.actions.declare_file(ctx.label.name + ".o")

    source_files = depset(transitive = [src.files for src in ctx.attr.srcs])
    shared_libraries = [dep[LangInfo].compiled for dep in ctx.attr.deps]

    variables = struct(
        output = output,
        source_files = source_files.to_list(),
        shared_libraries = shared_libraries
    )
    run_action(
        ctx,
        toolchain_config = toolchain,
        action_type = ctx.attr._compile_action[ActionTypeInfo],
        variables = variables,
    )
    return LangInfo(
        compiled = output,
        transitive_deps = depset([output], transitive = [dep[LangInfo].transitive_deps for dep in ctx.attr.deps])
    )



def _lang_library_impl(ctx):
    lang_info = _compile(ctx)
    return [
        DefaultInfo(files = depset([lang_info.compiled])),
        lang_info,
    ]

lang_library = rule(
    implementation = _lang_library_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(providers = [LangInfo]),
        "_compile_action": attr.label(default = "//lang/toolchain/actions:compile"),
    } | GENERIC_RULE_ATTRS,
    toolchains = [_LANG_TOOLCHAIN_TYPE],
    provides = [LangInfo],
)

def _lang_binary_impl(ctx):
    compile_info = _compile(ctx)

    toolchain = ctx.toolchains[_LANG_TOOLCHAIN_TYPE].config

    output = ctx.actions.declare_file(ctx.label.name)
    shared_libraries = compile_info.transitive_deps

    variables = struct(
        output = output,
        shared_libraries = shared_libraries.to_list()
    )
    run_action(
        ctx,
        toolchain_config = toolchain,
        action_type = ctx.attr._link_action[ActionTypeInfo],
        variables = variables,
    )
     
    return [
        compile_info,
        DefaultInfo(files = depset([output]), executable = output),
    ]

_BINARY_KWARGS = dict(
    implementation = _lang_binary_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(providers = [LangInfo]),
        "_compile_action": attr.label(default = "//lang/toolchain/actions:compile"),
        "_link_action": attr.label(default = "//lang/toolchain/actions:link"),
    } | GENERIC_RULE_ATTRS,
    toolchains = [_LANG_TOOLCHAIN_TYPE],
    provides = [LangInfo],
    executable = True,
)
lang_binary = rule(**_BINARY_KWARGS)
lang_test = rule(test=True, **_BINARY_KWARGS)