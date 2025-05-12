"""Rules for testing transitions for cross-compilation with toolchains"""

load("@rules_toolchains//tests/platforms:transitions.bzl", "target2_transition")
load("//lang:providers.bzl", "LangInfo")

def _target2_lang_library(ctx):
    info = ctx.attr.actual[LangInfo]
    return [
        DefaultInfo(files = depset([info.compiled])),
        info,
    ]

target2_lang_library = rule(
    implementation = _target2_lang_library,
    attrs = {
        "actual": attr.label(mandatory = True, cfg = target2_transition),
    },
)
