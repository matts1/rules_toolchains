# Copyright 2025 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""All providers for rule-based bazel toolchain config."""

load(
    "//toolchains/private:collect.bzl",
    "collect_action_types",
    "collect_files",
    "collect_provider",
)
load(
    ":toolchain_info.bzl",
    "ActionTypeSetInfo",
    "ArgsInfo",
    "ArgsListInfo",
    "FeatureConstraintInfo",
    "ListVariableInfo",
    "SingleVariableInfo",
    "TYPE_INPUT_FILE",
    "TYPE_OUTPUT_FILE",
)

visibility("public")

# We have no int variables, so this shouldn't match.
_MISSING = 3

COMMON_ATTRS = {
    "actions": attr.label_list(
        providers = [ActionTypeSetInfo],
        mandatory = True,
        doc = """The actions for which this arg is used. This arg will be skipped for all actions other than the ones listed here.""",
    ),
    "env": attr.string_dict(
        doc = """Environment variables to apply.""",
    ),
    "data": attr.label_list(
        allow_files = True,
        doc = "Data required for the arg. This does not include variables.",
    ),
    "requires": attr.label_list(
        providers = [FeatureConstraintInfo],
        doc = """A list of constraints, one of which must be met or an error will occur.""",
    ),
}

def base_add_args_impl(ctx, fill, *, allowed_actions = None, allowed_actions_cause = None, storage = None):
    """A basic implementation of args recommended to be used by all custom rules.

    Args:
        ctx: The ctx of the current rule.
        fill: Function(self, ExecutionContext, ctx.action.Args) A function that can modify the command-line being executed.
        allowed_actions: Optional[List[ActionTypeSetInfo]] A list of actions allowed for this action. Should be the intersection of the actions of all variables being accessed.
        allowed_actions_cause: Optional[str] What to report of the cause of the failure if the actions didn't match.
        storage: Any metadata to be stored, accessible via self.storage in the fill function.

    Returns:
        providers suitable for
    """
    actions = tuple([action.label for action in collect_action_types(ctx.attr.actions).to_list()])
    if allowed_actions != None:
        for action in actions:
            if action not in allowed_actions:
                fmt = " ".join(sorted(["  %s\n" % x for x in allowed_actions]))
                fail("%s is not a valid action for %s, which restricts the actions to:\n%s" % (action, allowed_actions_cause, fmt))

    args = ArgsInfo(
        label = ctx.label,
        actions = actions,
        requires = collect_provider(ctx.attr.requires, FeatureConstraintInfo),
        files = collect_files(ctx.attr.data),
        env = ctx.attr.env,
        fill = fill,
        storage = storage,
    )
    return [
        args,
        ArgsListInfo(label = ctx.label, args = tuple([args])),
    ]

def _args_add_strings_impl(ctx):
    def fill(self, execution_ctx, args):
        args.add_all(self.storage)
        execution_ctx.env.update(self.env)

    return base_add_args_impl(ctx, fill, allowed_actions = None, allowed_actions_cause = None, storage = ctx.attr.values)

args_add_strings = rule(
    implementation = _args_add_strings_impl,
    attrs = {
        "values": attr.string_list(mandatory = True, doc = "The strings to add to the command-line"),
    } | COMMON_ATTRS,
)

def get_variable(self, execution_ctx):
    """Retrieves a variable from the execution context.

    Args:
        self: (VariableInfo) The variable to retrieve.
        execution_ctx: (ExecutionContext) The context of execution.

    Returns:
        The value of the variable in the execution context."""
    variable = self.storage.variable
    value = getattr(execution_ctx.variables, variable.name, _MISSING)
    if value == _MISSING:
        fail("Variable %s was not provided, but is referenced by %s." % (variable.label, self.label))
    elif value == None and variable.mandatory:
        fail("Variable %s was None, but is marked as mandatory" % variable.label)
    return value

def _args_add_impl(ctx):
    def fill(self, execution_ctx, args):
        value = get_variable(self, execution_ctx)
        if value != None:
            if self.storage.arg_name != None:
                args.add(self.storage.arg_name, value, format = self.storage.format)
            else:
                args.add(value, format = self.storage.format)
            execution_ctx.env.update(self.env)
            if variable.type == TYPE_INPUT_FILE:
                execution_ctx.inputs.append(value)
            elif variable.type == TYPE_OUTPUT_FILE:
                execution_ctx.outputs.append(value)

    variable = ctx.attr.value[SingleVariableInfo]
    return base_add_args_impl(ctx, fill, allowed_actions = variable.actions, allowed_actions_cause = variable.label, storage = struct(
        arg_label = ctx.label,
        variable = variable,
        arg_name = ctx.attr.arg_name or None,
        format = ctx.attr.format or None,
    ))

args_add = rule(
    implementation = _args_add_impl,
    attrs = {
        "arg_name": attr.string(),
        "value": attr.label(
            providers = [SingleVariableInfo],
            mandatory = True,
            doc = "The variable to format",
        ),
        "format": attr.string(),
    } | COMMON_ATTRS,
    provides = [ArgsInfo],
    doc = """Roughly equivalent to `ctx.actions.args().add()`.

See [documentation](https://bazel.build/rules/lib/builtins/Args.html#add) for `ctx.actions.args().add()` for parameter documentation.

Example:
```
args_add(
    name = "...",
    arg_name = "prefix",
    format = "--foo=%s"
    value = ":foo",
)
```
""",
)

def _args_add_all_impl(ctx):
    def fill(self, execution_ctx, args):
        value = get_variable(self, execution_ctx)
        if self.storage.arg_name != None:
            args.add_all(self.storage.arg_name, value or [], omit_if_empty = self.storage.omit_if_empty, **self.storage.kwargs)
        else:
            args.add_all(value or [], omit_if_empty = self.storage.omit_if_empty, **self.storage.kwargs)
        if value:
            if variable.type == TYPE_INPUT_FILE:
                execution_ctx.inputs.extend(value)
            elif variable.type == TYPE_OUTPUT_FILE:
                execution_ctx.outputs.extend(value)
        if value or not self.storage.omit_if_empty:
            execution_ctx.env.update(self.env)

    variable = ctx.attr.value[ListVariableInfo]
    return base_add_args_impl(ctx, fill, allowed_actions = variable.actions, allowed_actions_cause = variable.label, storage = struct(
        variable = variable,
        arg_label = ctx.label,
        arg_name = ctx.attr.arg_name or None,
        kwargs = dict(
            format_each = ctx.attr.format_each or None,
            before_each = ctx.attr.before_each or None,
            uniquify = ctx.attr.uniquify,
            expand_directories = ctx.attr.expand_directories,
            terminate_with = ctx.attr.terminate_with or None,
        ),
        omit_if_empty = ctx.attr.omit_if_empty,
    ))

args_add_all = rule(
    implementation = _args_add_all_impl,
    attrs = {
        "arg_name": attr.string(),
        "value": attr.label(
            providers = [ListVariableInfo],
            mandatory = True,
            doc = "The variable to format",
        ),
        "before_each": attr.string(),
        "format_each": attr.string(),
        "omit_if_empty": attr.bool(default = True),
        "uniquify": attr.bool(default = False),
        "expand_directories": attr.bool(default = True),
        "terminate_with": attr.string(),
        "allow_closure": attr.bool(default = False),
    } | COMMON_ATTRS,
    doc = """Roughly equivalent to `ctx.actions.args().add_all()`.

See [documentation](https://bazel.build/rules/lib/builtins/Args.html#add_all) for `ctx.actions.args().add_all()` for parameter documentation.

Example:
```
args_add_all(
    name = "...",
    arg_name = "prefix",
    format_each = "--foo=%s"
    value = ":foo_list",
)
```
""",
    provides = [ArgsInfo],
)

def _args_add_joined_impl(ctx):
    def fill(self, execution_ctx, args):
        value = get_variable(self, execution_ctx)

        if self.storage.arg_name != None:
            args.add_joined(self.storage.arg_name, value or [], omit_if_empty = self.storage.omit_if_empty, **self.storage.kwargs)
        else:
            args.add_joined(value or [], omit_if_empty = self.storage.omit_if_empty, **self.storage.kwargs)
        if value:
            if variable.type == TYPE_INPUT_FILE:
                execution_ctx.inputs.extend(value)
            elif variable.type == TYPE_OUTPUT_FILE:
                execution_ctx.outputs.extend(value)
        if value or not self.storage.omit_if_empty:
            execution_ctx.env.update(self.env)

    variable = ctx.attr.value[ListVariableInfo]
    return base_add_args_impl(ctx, fill, allowed_actions = variable.actions, allowed_actions_cause = variable.label, storage = struct(
        variable = variable,
        arg_label = ctx.label,
        arg_name = ctx.attr.arg_name or None,
        kwargs = dict(
            join_with = ctx.attr.join_with,
            format_each = ctx.attr.format_each or None,
            format_joined = ctx.attr.format_joined or None,
            uniquify = ctx.attr.uniquify,
            expand_directories = ctx.attr.expand_directories,
        ),
        omit_if_empty = ctx.attr.omit_if_empty,
    ))

args_add_joined = rule(
    implementation = _args_add_joined_impl,
    attrs = {
        "arg_name": attr.string(default = ""),
        "value": attr.label(
            providers = [ListVariableInfo],
            mandatory = True,
            doc = "The variable to format",
        ),
        "join_with": attr.string(mandatory = True),
        "format_each": attr.string(),
        "format_joined": attr.string(),
        "omit_if_empty": attr.bool(default = True),
        "uniquify": attr.bool(default = False),
        "expand_directories": attr.bool(default = False),
    } | COMMON_ATTRS,
    doc = """Roughly equivalent to `ctx.actions.args().add_joined()`.

See [documentation](https://bazel.build/rules/lib/builtins/Args.html#add_joined) for `ctx.actions.args().add_joined()` for parameter documentation.

Example:
```
args_add_joined(
    name = "...",
    join_with = ","
    value = ":foo_list",
)
```
""",
    provides = [ArgsInfo],
)
