# Toolchain rules for bazel

This repository contains rules for configuring toolchains. It is designed to be integrated with rulesets to allow a ruleset to specify what they *want* an action to do, and have the configuration decide how to achieve that. For example, a ruleset author would specify `run_action(action_type=compile, variables = struct(header_files = [foo.h], source_files = [foo.cc], output = [foo.o]), inputs=[foo.cc, foo.h], outputs = [foo.o])`, and the configuration would turn that into the command-line `clang++ foo.cc foo.h -o foo.o`.

# Getting Started

Add the following to your `MODULE.bazel` file:

```starlark
bazel_dep(name = "rules_testing", version = "<version>")
```

## For ruleset authors

Look at `examples/rules_lang`. You will first need to configure your toolchain to take in a `ToolchainConfig` parameter.

Once you've done that, you'll need to configure your rule to, instead of calling `ctx.actions.run`, call `run_action` (see [`examples/rules_lang/lang/defs.bzl`](examples/rules_lang/lang/defs.bzl)).

## For toolchain authors
Either use the default toolchain configured by your ruleset author, or create a custom `toolchain_config` rule.

# Testing
`rules_toolchains` supports generating "input files". These files contain a full specification of generated actions, and can be used to validate that your toolchain configuration works as intended with golden tests. For an example of how this works, see `@rules_toolchain//tests`.

# Contributing

We appreciate your help!

To contribute, please read the contribution guidelines: [CONTRIBUTING.md](https://github.com/matts1/rules_toolchains/blob/main/CONTRIBUTING.md).
