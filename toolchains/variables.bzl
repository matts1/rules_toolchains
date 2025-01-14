# Copyright 2025 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Rules for accessing cc build variables in bazel toolchains safely."""

load(
    "//toolchains:toolchain_info.bzl",
    "ActionTypeSetInfo",
    "ListVariableInfo",
    "SingleVariableInfo",
    "TYPE_INPUT_FILE",
    "TYPE_OUTPUT_FILE",
    "TYPE_STRING",
)
load("//toolchains/private:collect.bzl", "collect_action_labels")

visibility("public")

_COMMON_ATTRS = {
    "actions": attr.label_list(
        providers = [ActionTypeSetInfo],
        mandatory = True,
        doc = "The actions for which the variable will be available.",
    ),
    "variable_name": attr.string(doc = "The field name in the variables this corresponds to. Defaults to name."),
}

_SINGLE_VARIABLE_KWARGS = {
    "attrs": {
        "mandatory": attr.bool(
            mandatory = True,
            doc = "If True, the variable cannot be None",
        ),
    } | _COMMON_ATTRS,
    "provides": [SingleVariableInfo],
}

_LIST_VARIABLE_KWARGS = {
    "attrs": {
        "actions": attr.label_list(
            providers = [ActionTypeSetInfo],
            mandatory = True,
            doc = "The actions for which the variable will be available.",
        ),
    } | _COMMON_ATTRS,
    "provides": [ListVariableInfo],
}

def _single_impl(kind):
    def fn(ctx):
        return [SingleVariableInfo(
            label = ctx.label,
            name = ctx.attr.variable_name or ctx.label.name,
            actions = tuple(collect_action_labels(ctx.attr.actions)),
            type = kind,
            mandatory = ctx.attr.mandatory,
        )]

    return fn

def _list_impl(kind):
    def fn(ctx):
        return [ListVariableInfo(
            label = ctx.label,
            name = ctx.attr.variable_name or ctx.label.name,
            actions = tuple(collect_action_labels(ctx.attr.actions)),
            type = kind,
        )]

    return fn

string_variable = rule(implementation = _single_impl(TYPE_STRING), **_SINGLE_VARIABLE_KWARGS)
string_list_variable = rule(implementation = _list_impl(TYPE_STRING), **_LIST_VARIABLE_KWARGS)
input_file_variable = rule(implementation = _single_impl(TYPE_INPUT_FILE), **_SINGLE_VARIABLE_KWARGS)
input_file_list_variable = rule(implementation = _list_impl(TYPE_INPUT_FILE), **_LIST_VARIABLE_KWARGS)
output_file_variable = rule(implementation = _single_impl(TYPE_OUTPUT_FILE), **_SINGLE_VARIABLE_KWARGS)
output_file_list_variable = rule(implementation = _list_impl(TYPE_OUTPUT_FILE), **_LIST_VARIABLE_KWARGS)
