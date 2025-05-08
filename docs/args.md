<!-- Generated with Stardoc: http://skydoc.bazel.build -->

All providers for rule-based bazel toolchain config.

<a id="args_add"></a>

## args_add

<pre>
load("@rules_toolchains//toolchains:args.bzl", "args_add")

args_add(<a href="#args_add-name">name</a>, <a href="#args_add-data">data</a>, <a href="#args_add-actions">actions</a>, <a href="#args_add-arg_name">arg_name</a>, <a href="#args_add-env">env</a>, <a href="#args_add-format">format</a>, <a href="#args_add-requires">requires</a>, <a href="#args_add-value">value</a>)
</pre>

Roughly equivalent to `ctx.actions.args().add()`.

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

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="args_add-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="args_add-data"></a>data |  Data required for the arg. This does not include variables.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="args_add-actions"></a>actions |  The actions for which this arg is used. This arg will be skipped for all actions other than the ones listed here.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="args_add-arg_name"></a>arg_name |  -   | String | optional |  `""`  |
| <a id="args_add-env"></a>env |  Environment variables to apply.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="args_add-format"></a>format |  -   | String | optional |  `""`  |
| <a id="args_add-requires"></a>requires |  A list of constraints, one of which must be met or an error will occur.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="args_add-value"></a>value |  The variable to format   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |


<a id="args_add_all"></a>

## args_add_all

<pre>
load("@rules_toolchains//toolchains:args.bzl", "args_add_all")

args_add_all(<a href="#args_add_all-name">name</a>, <a href="#args_add_all-data">data</a>, <a href="#args_add_all-actions">actions</a>, <a href="#args_add_all-arg_name">arg_name</a>, <a href="#args_add_all-before_each">before_each</a>, <a href="#args_add_all-env">env</a>, <a href="#args_add_all-expand_directories">expand_directories</a>, <a href="#args_add_all-format_each">format_each</a>,
             <a href="#args_add_all-omit_if_empty">omit_if_empty</a>, <a href="#args_add_all-requires">requires</a>, <a href="#args_add_all-terminate_with">terminate_with</a>, <a href="#args_add_all-uniquify">uniquify</a>, <a href="#args_add_all-value">value</a>)
</pre>

Roughly equivalent to `ctx.actions.args().add_all()`.

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

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="args_add_all-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="args_add_all-data"></a>data |  Data required for the arg. This does not include variables.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="args_add_all-actions"></a>actions |  The actions for which this arg is used. This arg will be skipped for all actions other than the ones listed here.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="args_add_all-arg_name"></a>arg_name |  -   | String | optional |  `""`  |
| <a id="args_add_all-before_each"></a>before_each |  -   | String | optional |  `""`  |
| <a id="args_add_all-env"></a>env |  Environment variables to apply.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="args_add_all-expand_directories"></a>expand_directories |  -   | Boolean | optional |  `True`  |
| <a id="args_add_all-format_each"></a>format_each |  -   | String | optional |  `""`  |
| <a id="args_add_all-omit_if_empty"></a>omit_if_empty |  -   | Boolean | optional |  `True`  |
| <a id="args_add_all-requires"></a>requires |  A list of constraints, one of which must be met or an error will occur.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="args_add_all-terminate_with"></a>terminate_with |  -   | String | optional |  `""`  |
| <a id="args_add_all-uniquify"></a>uniquify |  -   | Boolean | optional |  `False`  |
| <a id="args_add_all-value"></a>value |  The variable to format   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |


<a id="args_add_joined"></a>

## args_add_joined

<pre>
load("@rules_toolchains//toolchains:args.bzl", "args_add_joined")

args_add_joined(<a href="#args_add_joined-name">name</a>, <a href="#args_add_joined-data">data</a>, <a href="#args_add_joined-actions">actions</a>, <a href="#args_add_joined-arg_name">arg_name</a>, <a href="#args_add_joined-env">env</a>, <a href="#args_add_joined-expand_directories">expand_directories</a>, <a href="#args_add_joined-format_each">format_each</a>, <a href="#args_add_joined-format_joined">format_joined</a>,
                <a href="#args_add_joined-join_with">join_with</a>, <a href="#args_add_joined-omit_if_empty">omit_if_empty</a>, <a href="#args_add_joined-requires">requires</a>, <a href="#args_add_joined-uniquify">uniquify</a>, <a href="#args_add_joined-value">value</a>)
</pre>

Roughly equivalent to `ctx.actions.args().add_joined()`.

See [documentation](https://bazel.build/rules/lib/builtins/Args.html#add_joined) for `ctx.actions.args().add_joined()` for parameter documentation.

Example:
```
args_add_joined(
    name = "...",
    join_with = ","
    value = ":foo_list",
)
```

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="args_add_joined-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="args_add_joined-data"></a>data |  Data required for the arg. This does not include variables.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="args_add_joined-actions"></a>actions |  The actions for which this arg is used. This arg will be skipped for all actions other than the ones listed here.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="args_add_joined-arg_name"></a>arg_name |  -   | String | optional |  `""`  |
| <a id="args_add_joined-env"></a>env |  Environment variables to apply.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="args_add_joined-expand_directories"></a>expand_directories |  -   | Boolean | optional |  `False`  |
| <a id="args_add_joined-format_each"></a>format_each |  -   | String | optional |  `""`  |
| <a id="args_add_joined-format_joined"></a>format_joined |  -   | String | optional |  `""`  |
| <a id="args_add_joined-join_with"></a>join_with |  -   | String | required |  |
| <a id="args_add_joined-omit_if_empty"></a>omit_if_empty |  -   | Boolean | optional |  `True`  |
| <a id="args_add_joined-requires"></a>requires |  A list of constraints, one of which must be met or an error will occur.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="args_add_joined-uniquify"></a>uniquify |  -   | Boolean | optional |  `False`  |
| <a id="args_add_joined-value"></a>value |  The variable to format   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |


<a id="args_add_strings"></a>

## args_add_strings

<pre>
load("@rules_toolchains//toolchains:args.bzl", "args_add_strings")

args_add_strings(<a href="#args_add_strings-name">name</a>, <a href="#args_add_strings-data">data</a>, <a href="#args_add_strings-actions">actions</a>, <a href="#args_add_strings-env">env</a>, <a href="#args_add_strings-requires">requires</a>, <a href="#args_add_strings-values">values</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="args_add_strings-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="args_add_strings-data"></a>data |  Data required for the arg. This does not include variables.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="args_add_strings-actions"></a>actions |  The actions for which this arg is used. This arg will be skipped for all actions other than the ones listed here.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="args_add_strings-env"></a>env |  Environment variables to apply.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="args_add_strings-requires"></a>requires |  A list of constraints, one of which must be met or an error will occur.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="args_add_strings-values"></a>values |  The strings to add to the command-line   | List of strings | required |  |


<a id="base_add_args_impl"></a>

## base_add_args_impl

<pre>
load("@rules_toolchains//toolchains:args.bzl", "base_add_args_impl")

base_add_args_impl(<a href="#base_add_args_impl-ctx">ctx</a>, <a href="#base_add_args_impl-fill">fill</a>, *, <a href="#base_add_args_impl-allowed_actions">allowed_actions</a>, <a href="#base_add_args_impl-allowed_actions_cause">allowed_actions_cause</a>, <a href="#base_add_args_impl-storage">storage</a>)
</pre>

A basic implementation of args recommended to be used by all custom rules.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="base_add_args_impl-ctx"></a>ctx |  The ctx of the current rule.   |  none |
| <a id="base_add_args_impl-fill"></a>fill |  Function(self, ExecutionContext, ctx.action.Args) A function that can modify the command-line being executed.   |  none |
| <a id="base_add_args_impl-allowed_actions"></a>allowed_actions |  Optional[List[ActionTypeSetInfo]] A list of actions allowed for this action. Should be the intersection of the actions of all variables being accessed.   |  `None` |
| <a id="base_add_args_impl-allowed_actions_cause"></a>allowed_actions_cause |  Optional[str] What to report of the cause of the failure if the actions didn't match.   |  `None` |
| <a id="base_add_args_impl-storage"></a>storage |  Any metadata to be stored, accessible via self.storage in the fill function.   |  `None` |

**RETURNS**

providers suitable for


<a id="get_variable"></a>

## get_variable

<pre>
load("@rules_toolchains//toolchains:args.bzl", "get_variable")

get_variable(<a href="#get_variable-self">self</a>, <a href="#get_variable-execution_ctx">execution_ctx</a>)
</pre>

Retrieves a variable from the execution context.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="get_variable-self"></a>self |  (VariableInfo) The variable to retrieve.   |  none |
| <a id="get_variable-execution_ctx"></a>execution_ctx |  (ExecutionContext) The context of execution.   |  none |

**RETURNS**

The value of the variable in the execution context.


