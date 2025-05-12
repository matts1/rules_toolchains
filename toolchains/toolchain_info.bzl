# Copyright 2024 The Bazel Authors. All rights reserved.
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

visibility(["public"])

TYPE_STRING = 0
TYPE_INPUT_FILE = 1
TYPE_OUTPUT_FILE = 2

ActionTypeInfo = provider(
    doc = "A type of action (eg. c-compile, c++-link-executable)",
    # @unsorted-dict-items
    fields = {
        "label": "(Label) The label defining this provider. Place in error messages to simplify debugging",
        "mnemonic": "(string) The mnemonic to use for this action",
    },
)

ActionTypeSetInfo = provider(
    doc = "A set of types of actions",
    # @unsorted-dict-items
    fields = {
        "label": "(Label) The label defining this provider. Place in error messages to simplify debugging",
        "actions": "(depset[ActionTypeInfo]) Set of action types",
    },
)

SingleVariableInfo = provider(
    """A variable defined by the toolchain""",
    # @unsorted-dict-items
    fields = {
        "label": "(Label) The label defining this provider. Place in error messages to simplify debugging",
        "name": "(string) The name of the variable",
        "actions": "(Sequence[Label]) The actions this variable is available for",
        "type": "A type as defined at the top of this file",
        "mandatory": "(bool) Whether this variable can be none",
    },
)

ListVariableInfo = provider(
    """A variable defined by the toolchain""",
    # @unsorted-dict-items
    fields = {
        "label": "(Label) The label defining this provider. Place in error messages to simplify debugging",
        "name": "(string) The name of the variable",
        "actions": "(Sequence[Label]) The actions this variable is available for",
        "type": "A type as defined at the top of this file",
    },
)

ArgsInfo = provider(
    doc = "A set of arguments to be added to the command line for specific actions",
    # @unsorted-dict-items
    fields = {
        "label": "(Label) The label defining this provider. Place in error messages to simplify debugging",
        "actions": "(Sequence[Label]]) The set of actions this is associated with",
        "requires": "(Sequence[FeatureConstraintInfo]) This will be skipped if none of the listed predicates are met.",
        "files": "(depset[File]) Files required for the args",
        "env": "(dict[str, str]) Environment variables to apply",
        "fill": "(Function(self, execution_ctx, ctx.action.Args)) The mechanism to resolve the args to something that actually runs on the command line.",
        "storage": "(any) Storage for arbitrary data to be used by the fill function",
    },
)

ArgsListInfo = provider(
    doc = "A ordered list of arguments",
    # @unsorted-dict-items
    fields = {
        "label": "(Label) The label defining this provider. Place in error messages to simplify debugging",
        "args": "(Sequence[ArgsInfo]) The flag sets contained within",
    },
)

FeatureInfo = provider(
    doc = "Contains all flag specifications for one feature.",
    # @unsorted-dict-items
    fields = {
        "label": "(Label) The label defining this provider. Place in error messages to simplify debugging",
        "args": "(Sequence[ArgsInfo]) Args enabled by this feature",
        "implies": "(Sequence[FeatureInfo]) Set of features implied by this feature",
        "requires": "(SmallSet[FeatureConstraintInfo]) A list of feature constraints, at least one of which is required to enable this feature. This is semantically equivalent to the requires attribute of rules_cc's FeatureInfo",
        "mutually_exclusive": "(Sequence[MutuallyExclusiveCategoryInfo]) Indicates that this feature is one of several mutually exclusive alternate features.",
        "late_validate": "(bool) Whether the feature is should be validated late",
    },
)

FeatureSetInfo = provider(
    doc = "A set of features",
    # @unsorted-dict-items
    fields = {
        "label": "(Label) The label defining this provider. Place in error messages to simplify debugging",
        "features": "(depset[FeatureInfo]) The set of features this corresponds to",
    },
)

FeatureConstraintInfo = provider(
    doc = "A predicate checking that certain features are enabled and others disabled.",
    # @unsorted-dict-items
    fields = {
        "label": "(Label) The label defining this provider. Place in error messages to simplify debugging",
        "storage": "(any) Storage accessible by the validate function",
        "validate": "(Function(self, features) -> error) A function that validates that the constraint is met. Returns a string containing an error message, or None on success",
    },
)

MutuallyExclusiveCategoryInfo = provider(
    doc = "Multiple features with the category will be mutally exclusive",
    # @unsorted-dict-items
    fields = {
        "label": "(Label) The label defining this provider. Place in error messages to simplify debugging",
    },
)

ToolInfo = provider(
    doc = "A binary, with additional metadata to make it useful for action configs.",
    # @unsorted-dict-items
    fields = {
        "label": "(Label) The label defining this provider. Place in error messages to simplify debugging",
        "exe": "(File) The file corresponding to the tool",
        "runfiles": "(runfiles) The files needed to run the executable",
        "execution_requirements": "(Sequence[str]) A set of execution requirements of the tool",
        "capabilities": "(Sequence[ToolCapabilityInfo]) Capabilities supported by the tool.",
    },
)

ToolCapabilityInfo = provider(
    doc = "A capability associated with a tool (eg. supports_pic).",
    # @unsorted-dict-items
    fields = {
        "label": "(Label) The label defining this provider. Place in error messages to simplify debugging",
        "feature": "(FeatureInfo) The feature this capability defines",
    },
)

ToolMapInfo = provider(
    doc = "A mapping from action to tool",
    # @unsorted-dict-items
    fields = {
        "label": "(Label) The label defining this provider. Place in error messages to simplify debugging",
        "configs": "(dict[Label, ToolInfo]) A mapping from action type to tool.",
    },
)

ToolchainConfigInfo = provider(
    doc = "The configuration for a toolchain",
    # @unsorted-dict-items
    fields = {
        "label": "(Label) The label defining this provider. Place in error messages to simplify debugging",
        "enabled_features": "(SmallSet[FeatureInfo]) The features That are explicitly enabled by default for this toolchain",
        # Not strictly required, but this allows us to skip feature
        # calculation and validation unless the user explicitly specifies
        # enabled_features or disabled_features.
        "defaults_by_action": "(dict[Label, struct]]) A mapping from action type to some defaults for that action type.",
        "tool_map": "(ToolMapInfo) A provider mapping toolchain action types to tools.",
    },
)
