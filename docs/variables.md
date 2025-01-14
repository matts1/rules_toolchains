<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Rules for accessing cc build variables in bazel toolchains safely.

<a id="input_file_list_variable"></a>

## input_file_list_variable

<pre>
load("@rules_toolchains//toolchains:variables.bzl", "input_file_list_variable")

input_file_list_variable(<a href="#input_file_list_variable-name">name</a>, <a href="#input_file_list_variable-actions">actions</a>, <a href="#input_file_list_variable-variable_name">variable_name</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="input_file_list_variable-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="input_file_list_variable-actions"></a>actions |  The actions for which the variable will be available.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="input_file_list_variable-variable_name"></a>variable_name |  The field name in the variables this corresponds to. Defaults to name.   | String | optional |  `""`  |


<a id="input_file_variable"></a>

## input_file_variable

<pre>
load("@rules_toolchains//toolchains:variables.bzl", "input_file_variable")

input_file_variable(<a href="#input_file_variable-name">name</a>, <a href="#input_file_variable-actions">actions</a>, <a href="#input_file_variable-mandatory">mandatory</a>, <a href="#input_file_variable-variable_name">variable_name</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="input_file_variable-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="input_file_variable-actions"></a>actions |  The actions for which the variable will be available.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="input_file_variable-mandatory"></a>mandatory |  If True, the variable cannot be None   | Boolean | required |  |
| <a id="input_file_variable-variable_name"></a>variable_name |  The field name in the variables this corresponds to. Defaults to name.   | String | optional |  `""`  |


<a id="output_file_list_variable"></a>

## output_file_list_variable

<pre>
load("@rules_toolchains//toolchains:variables.bzl", "output_file_list_variable")

output_file_list_variable(<a href="#output_file_list_variable-name">name</a>, <a href="#output_file_list_variable-actions">actions</a>, <a href="#output_file_list_variable-variable_name">variable_name</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="output_file_list_variable-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="output_file_list_variable-actions"></a>actions |  The actions for which the variable will be available.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="output_file_list_variable-variable_name"></a>variable_name |  The field name in the variables this corresponds to. Defaults to name.   | String | optional |  `""`  |


<a id="output_file_variable"></a>

## output_file_variable

<pre>
load("@rules_toolchains//toolchains:variables.bzl", "output_file_variable")

output_file_variable(<a href="#output_file_variable-name">name</a>, <a href="#output_file_variable-actions">actions</a>, <a href="#output_file_variable-mandatory">mandatory</a>, <a href="#output_file_variable-variable_name">variable_name</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="output_file_variable-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="output_file_variable-actions"></a>actions |  The actions for which the variable will be available.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="output_file_variable-mandatory"></a>mandatory |  If True, the variable cannot be None   | Boolean | required |  |
| <a id="output_file_variable-variable_name"></a>variable_name |  The field name in the variables this corresponds to. Defaults to name.   | String | optional |  `""`  |


<a id="string_list_variable"></a>

## string_list_variable

<pre>
load("@rules_toolchains//toolchains:variables.bzl", "string_list_variable")

string_list_variable(<a href="#string_list_variable-name">name</a>, <a href="#string_list_variable-actions">actions</a>, <a href="#string_list_variable-variable_name">variable_name</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="string_list_variable-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="string_list_variable-actions"></a>actions |  The actions for which the variable will be available.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="string_list_variable-variable_name"></a>variable_name |  The field name in the variables this corresponds to. Defaults to name.   | String | optional |  `""`  |


<a id="string_variable"></a>

## string_variable

<pre>
load("@rules_toolchains//toolchains:variables.bzl", "string_variable")

string_variable(<a href="#string_variable-name">name</a>, <a href="#string_variable-actions">actions</a>, <a href="#string_variable-mandatory">mandatory</a>, <a href="#string_variable-variable_name">variable_name</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="string_variable-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="string_variable-actions"></a>actions |  The actions for which the variable will be available.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="string_variable-mandatory"></a>mandatory |  If True, the variable cannot be None   | Boolean | required |  |
| <a id="string_variable-variable_name"></a>variable_name |  The field name in the variables this corresponds to. Defaults to name.   | String | optional |  `""`  |


