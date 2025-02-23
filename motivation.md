## What is a ruleset

A ruleset is a set of rules, where each rule needs to decide _what_ needs to be done, and _how_ to do it. For example, for `cc_library(name = "foo", srcs = ["foo.cc"])`, the what would be "compile foo.o from foo.cc", and the how would be `gcc -c foo.rs -o foo.o`.

However, to throw a spanner in the works, toolchain authors don't really care about the what, but care very strongly about the how. For example, they might say:

- We need to build with our super-special compiler that we built ourself
- We want to build with this specific set of flags
- We don't actually want these default flags you've provided
- We want to compile with these specific set of flags, but not link with them, and only under some very specific set of conditions

To this end, each ruleset generally comes with its own way of supporting configurability.

## How does a rule implement configurability

An example from rules_rust (artistic liberties taken):

```python
def _rust_library_impl(ctx):
  output = ctx.actions.declare_file(ctx.label.name + ".o")
  args = ctx.actions.args()
  args.add("-o", output)
  args.add("--crate_name", ctx.attr.crate_name)
  args.add_all([dep[CrateInfo].lib for lib in ctx.attr.dep])
  args.add_all(toolchain.extra_rustc_flags)
  args.add_all(toolchain.extra_rustc_flags_for_crate_types[ctx.attr.crate_type])
  features = native.get_features()
  if "foo" in features:
    args.add("--foo")
  ctx.actions.run(
    inputs = [ctx.src.file],
    outputs = [output],
    args = [args],
  )
  return [CrateInfo(lib = output)]
```

Note that in the initial implementation, `extra_rustc_flags_for_crate_types` wasn't suppported, and had to be explicitly supported after the fact because my team decided they needed it (https://github.com/bazelbuild/rules_rust/pull/2431).

Toolchains have a horrible reputation for being scary and hard to understand, and not without good reason. I can spend years working on C++ toolchains, then find that rust toolchain configurability is done completely differently. This is additional work for each ruleset to support, and is generally implemented on-demand, and so each time someone wants to configure something that hasn't been asked for a new flag is added to the toolchain configuration.

## Solution

We allow rulesets to decide _what_ needs to be done, and allow them to delegate the decision of _how_ to `rules_toolchains`.

In the example above, they would instead write:

```python
def _rust_library_impl(ctx):
  output = ctx.actions.declare_file(ctx.label.name + ".o")
  run_action(
    action_type = ctx.attr._compile_action
    variables = struct(
        crate_name = ctx.attr.crate_name,
        source_files = [ctx.src.file],
        output = output,
    )
  )
  return [CrateInfo(lib = output)]
```

The ruleset author would then provide:

### Actions

What kind of thing are you doing

```python
action(name = "compile")
action(name = "link")
```

### Variables

What information does that need

```python
input_file_list_variable(
    name = "source_files",
    # Variable is only accessible during compilation
    actions = ["//actions:compile"]
)

output_file_variable(
    name = "output",
    actions = ["//actions:compile", "//actions:link"]
)
```

### Reasonable default arguments

```python
args_add_all(
    name = "source_files",
    before_each = "-c",
    variable = "//variables:source_files"
)

args_add(
    name = "output",
    arg_name = "-o",
    variable = "//variables:output",
)

feature(
    name = "default_args",
    args = [
        ":source_files",
        ":output_file",
    ]
)
```

### Default tools

```python
tool(
   name = "rustc",
   src = "@rust_prebuilts//:rustc"
)

tool_map(
    name = "tools",
    tool_map = {
        "//actions:rustc": ":rustc"
    }
)
```

### Default toolchain

```python
toolchain_config(
    name = "default_toolchain",
    tool_map = "//tools",
    default_features = ["//args:default_args"],
)
```

would then be responsible for turning that into a command-line.

# Configurability for toolchain authors

- You can toggle a feature with `select` to decide whether to put it in default_features
- You can toggle whether a feature is enabled by simply writing `enabled_features` or `disabled_features` on an indivudual target (similar to `features = ["foo", "-bar"]`), and it will know what changes to args are required.
- Custom rules returning `ArgsInfo` allow for arbitrarily complex decisions on what to add to the command-line
