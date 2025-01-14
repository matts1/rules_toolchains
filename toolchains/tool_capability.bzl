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
"""Implementation of the tool_capability rule."""

load("//toolchains/private:small_set.bzl", "EMPTY_SMALL_SET")
load(
    ":toolchain_info.bzl",
    "FeatureConstraintInfo",
    "FeatureInfo",
    "ToolCapabilityInfo",
)

def _tool_capability_impl(ctx):
    ft = FeatureInfo(
        label = ctx.label,
        args = EMPTY_SMALL_SET,
        implies = EMPTY_SMALL_SET,
        requires = (),
        mutually_exclusive = (),
    )

    def validate(self, features):
        if self.label not in features:
            return "%s is unsupported by the current tool" % self.label
        return None

    return [
        ToolCapabilityInfo(label = ctx.label, feature = ft),
        # Only give it a feature constraint info and not a feature info.
        # This way you can't imply it - you can only require it.
        FeatureConstraintInfo(
            label = ctx.label,
            storage = None,
            validate = validate,
        ),
    ]

tool_capability = rule(
    implementation = _tool_capability_impl,
    provides = [ToolCapabilityInfo, FeatureConstraintInfo],
    doc = """A capability is an optional feature that a tool supports.

For example, not all compilers support PIC, so to handle this, we write:

```
tool(
    name = "clang",
    src = "@host_tools/bin/clang",
    capabilities = [
        "//toolchains/capabilities:supports_pic",
    ],
)

args(
    name = "pic",
    requires = [
        "//toolchains/capabilities:supports_pic"
    ],
    args = ["-fPIC"],
)
```

This ensures that `-fPIC` is added to the command-line only when we are using a
tool that supports PIC.
""",
    attrs = {
        "feature_name": attr.string(doc = "The name of the feature to generate for this capability"),
    },
)
