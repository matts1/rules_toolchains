# Semantically equivalent to a depset, but optimized for tiny sizes and for iteration (depset requires .to_list each time you want to iterate).

def create_small_set(values):
    # dedup
    return tuple({x.label: x for x in values}.values())

EMPTY_SMALL_SET = create_small_set([])

def merge_small_sets(sets):
    if len(sets) == 1:
        return sets[0]
    values = {}
    for set in sets:
        values.update({x.label: x for x in set})
    return tuple(values.values())