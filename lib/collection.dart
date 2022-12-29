/// A collection of iterable extensions and new collection types: bi-map,
/// bit-list, multi-set, set and list multi-map, range, and string.
export 'src/collection/bimap.dart'
    show BiMap, BiMapOnMapExtension, BiMapOnIterableExtension;
export 'src/collection/bitlist.dart' show BitList, BitListExtension;
export 'src/collection/heap.dart' show Heap;
export 'src/collection/iterable/chunked.dart' show ChunkedExtension;
export 'src/collection/iterable/combinations.dart' show CombinationsExtension;
export 'src/collection/iterable/count.dart' show CountIterableExtension;
export 'src/collection/iterable/flat_map.dart' show FlatMapExtension;
export 'src/collection/iterable/flatten.dart' show FlattenExtension;
export 'src/collection/iterable/group.dart' show GroupExtension, Group;
export 'src/collection/iterable/indexed.dart' show IndexedExtension, Indexed;
export 'src/collection/iterable/iterate.dart' show iterate;
export 'src/collection/iterable/operators.dart' show OperatorsExtension;
export 'src/collection/iterable/periodical.dart'
    show Period, PeriodicalExtension, TruncateExtension;
export 'src/collection/iterable/permutations.dart' show PermutationsExtension;
export 'src/collection/iterable/power_set.dart' show PowerSetExtension;
export 'src/collection/iterable/product.dart' show ProductExtension;
export 'src/collection/iterable/random.dart' show RandomExtension;
export 'src/collection/iterable/repeat_element.dart' show repeat;
export 'src/collection/iterable/repeat_iterable.dart'
    show RepeatIterableExtension;
export 'src/collection/iterable/separated.dart' show SeparatedExtension;
export 'src/collection/iterable/to_map.dart' show ToMapExtension;
export 'src/collection/iterable/unique.dart' show UniqueExtension;
export 'src/collection/iterable/window.dart' show WindowExtension;
export 'src/collection/iterable/zip.dart' show ZipExtension;
export 'src/collection/list/rotate.dart'
    show RotateListExtension, RotateQueueExtension;
export 'src/collection/list/take_skip.dart' show TakeSkipListExtension;
export 'src/collection/map/default.dart'
    show DefaultMapExtension, MapWithDefault;
export 'src/collection/multimap/list.dart'
    show
        ListMultimap,
        ListMultimapOnMapExtension,
        ListMultimapOnIterableExtension;
export 'src/collection/multimap/set.dart'
    show SetMultimap, SetMultimapOnMapExtension, SetMultimapOnIterableExtension;
export 'src/collection/multiset.dart' show Multiset, MultisetExtension;
export 'src/collection/range.dart' show Range, RangeIterator;
export 'src/collection/range/bigint.dart'
    show BigIntRange, BigIntRangeExtension;
export 'src/collection/range/double.dart'
    show DoubleRange, DoubleRangeExtension;
export 'src/collection/range/integer.dart'
    show IntegerRange, IntegerRangeExtension, IndicesIterableExtension;
export 'src/collection/rtree.dart' show RTree;
export 'src/collection/rtree/bounds.dart' show Bounds;
export 'src/collection/rtree/entry.dart' show RTreeEntry;
export 'src/collection/rtree/node.dart' show RTreeNode;
export 'src/collection/sortedlist.dart'
    show SortedList, SortedListIterableExtension;
export 'src/collection/string/convert_first_last.dart'
    show ConvertFirstLastStringExtension;
export 'src/collection/string/indent_dedent.dart'
    show IndentDedentStringExtension;
export 'src/collection/string/prefix_suffix.dart'
    show PrefixSuffixStringExtension;
export 'src/collection/string/string_list.dart' show StringListExtension;
export 'src/collection/string/take_skip.dart' show TakeSkipStringExtension;
export 'src/collection/string/wrap_unwrap.dart' show WrapUnwrapStringExtension;
export 'src/collection/trie.dart'
    show Trie, TrieNode, TrieNodeEntry, TrieNodeList, TrieNodeMap;
export 'src/collection/typemap.dart' show TypeMap;
