# Template for Bazel rules

Copy this template to create a Bazel ruleset.

Features:

- follows the official style guide at https://bazel.build/rules/deploying
- allows for both WORKSPACE.bazel and bzlmod (MODULE.bazel) usage
- includes Bazel formatting as a pre-commit hook (using [buildifier])
- includes stardoc API documentation generator
- includes typical toolchain setup
- CI configured with GitHub Actions
- release using GitHub Actions just by pushing a tag
- the release artifact doesn't need to be built by Bazel, but can still exclude files and stamp the version

# Bazel rules for toolchains

## Installation

From the release you wish to use:
<https://github.com/matts1/rules_toolchains/releases>
copy the WORKSPACE snippet into your `WORKSPACE` file.

To use a commit rather than a release, you can point at any SHA of the repo.

For example to use commit `abc123`:

1. Replace `url = "https://github.com/matts1/rules_toolchains/releases/download/v0.1.0/rules_toolchains-v0.1.0.tar.gz"` with a GitHub-provided source archive like `url = "https://github.com/matts1/rules_toolchains/archive/abc123.tar.gz"`
1. Replace `strip_prefix = "rules_toolchains-0.1.0"` with `strip_prefix = "rules_toolchains-abc123"`
1. Update the `sha256`. The easiest way to do this is to comment out the line, then Bazel will
   print a message with the correct value. Note that GitHub source archives don't have a strong
   guarantee on the sha256 stability, see
   <https://github.blog/2023-02-21-update-on-the-future-stability-of-source-code-archives-and-hashes/>
