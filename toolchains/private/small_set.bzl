"""Semantically equivalent to a depset, but optimized for tiny sizes and for iteration (depset requires .to_list each time you want to iterate)."""

visibility("//toolchains")

def create_small_set(values):
    """Creates a small set from a Sequence of values.

    Args:
        values: (Sequence[provider]) Values to merge

    Returns:
        A deduplicated set small set of providers.
    """

    # dedup
    return tuple({x.label: x for x in values}.values())

EMPTY_SMALL_SET = create_small_set([])

def merge_small_sets(sets):
    """Merges a sequence of small sets into one.

    Args:
      sets: (Sequence[SmallSet]) A sequence of small sets to join.

    Returns:
      All sets merged together.
    """
    if len(sets) == 1:
        return sets[0]
    values = {}
    for set in sets:
        values.update({x.label: x for x in set})
    return tuple(values.values())
