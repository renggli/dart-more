/// A collection of iterable extensions and new collection types: bi-map,
/// bit-list, multi-set, set and list multi-map, range, and string.
library collection;

export 'src/collection/bimap.dart'
    show BiMap, BiMapOnIterableExtension, BiMapOnMapExtension;
export 'src/collection/bitlist.dart' show BitList, BitListExtension;
export 'src/collection/iterable/chunked.dart' show ChunkedIterableExtension;
export 'src/collection/iterable/combinations.dart'
    show CombinationsIterableExtension;
export 'src/collection/iterable/count.dart' show CountIterableExtension;
export 'src/collection/iterable/flat_map.dart' show FlatMapIterableExtension;
export 'src/collection/iterable/flatten.dart'
    show DeepFlattenIterableExtension, FlattenIterableExtension;
export 'src/collection/iterable/group.dart'
    show Group, GroupIterableExtension, GroupMapEntryExtension;
export 'src/collection/iterable/indexed.dart'
    show Indexed, IndexedIterableExtension, IndexedMapEntryExtension;
export 'src/collection/iterable/iterate.dart' show iterate;
export 'src/collection/iterable/operators.dart' show OperatorsIterableExtension;
export 'src/collection/iterable/pairwise.dart' show PairwiseIterableExtension;
export 'src/collection/iterable/partition.dart' show PartitionIterableExtension;
export 'src/collection/iterable/permutations.dart'
    show PermutationComparableListExtension, PermutationIterableExtension;
export 'src/collection/iterable/power_set.dart' show PowerSetIterableExtension;
export 'src/collection/iterable/product.dart'
    show Product2IterableExtension, ProductIterableExtension;
export 'src/collection/iterable/random.dart' show RandomIterableExtension;
export 'src/collection/iterable/repeat_element.dart' show repeat;
export 'src/collection/iterable/repeat_iterable.dart'
    show RepeatIterableExtension;
export 'src/collection/iterable/separated.dart' show SeparatedIterableExtension;
export 'src/collection/iterable/to_map.dart' show ToMapIterableExtension;
export 'src/collection/iterable/unique.dart' show UniqueIterableExtension;
export 'src/collection/iterable/window.dart' show WindowIterableExtension;
export 'src/collection/iterable/zip.dart'
    show Zip2IterableExtension, ZipIterableExtension;
export 'src/collection/list/rotate.dart'
    show RotateListExtension, RotateQueueExtension;
export 'src/collection/list/take_skip.dart' show TakeSkipListExtension;
export 'src/collection/map/default.dart'
    show DefaultMapExtension, MapWithDefault;
export 'src/collection/multimap/list.dart'
    show
        ListMultimap,
        ListMultimapOnIterableExtension,
        ListMultimapOnMapExtension;
export 'src/collection/multimap/set.dart'
    show SetMultimap, SetMultimapOnIterableExtension, SetMultimapOnMapExtension;
export 'src/collection/multiset.dart' show Multiset, MultisetExtension;
export 'src/collection/range.dart' show Range, RangeIterator;
export 'src/collection/range/bigint.dart'
    show BigIntRange, BigIntRangeExtension;
export 'src/collection/range/double.dart'
    show DoubleRange, DoubleRangeExtension;
export 'src/collection/range/integer.dart'
    show IndicesIterableExtension, IntegerRange, IntegerRangeExtension;
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
export 'src/collection/string/partition.dart' show PartitionStringExtension;
export 'src/collection/string/prefix_suffix.dart'
    show PrefixSuffixStringExtension;
export 'src/collection/string/string_list.dart' show StringListExtension;
export 'src/collection/string/take_skip.dart' show TakeSkipStringExtension;
export 'src/collection/string/wrap_unwrap.dart' show WrapUnwrapStringExtension;
export 'src/collection/trie.dart'
    show Trie, TrieNode, TrieNodeEntry, TrieNodeList, TrieNodeMap;
export 'src/collection/typemap.dart' show TypeMap;
