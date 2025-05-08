"""Transitions for testing cross-compilation with toolchains."""

_PLATFORM = "//command_line_option:platforms"

def _target2_transition_impl(*_):
    return {_PLATFORM: "@rules_toolchains//tests/platforms:target_platform2"}

target2_transition = transition(
    implementation = _target2_transition_impl,
    inputs = [],
    outputs = [_PLATFORM],
)
