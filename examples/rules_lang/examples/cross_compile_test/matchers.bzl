"""Helpers for making rules_testing simpler to use"""

load("@rules_testing//lib:truth.bzl", "matching")

def error_matching(want_error):
    """Matches an error against an error

    Args:
        want_error: (str) The expected error

    Returns:
        An implementation suitable for an analysis_test
    """

    def impl(env, target):
        env.expect.that_target(target).failures().contains_predicate(matching.contains(want_error))

    return impl
