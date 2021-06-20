/// A collection of new collection types: bi-map, bit-list, multi-set, set and
/// list multi-map, range, and string.
export 'src/collection/bimap.dart'
    show BiMap, BiMapOnMapExtension, BiMapOnIterableExtension;
export 'src/collection/bitlist.dart' show BitList, BitListExtension;
export 'src/collection/multimap/list.dart'
    show
        ListMultimap,
        ListMultimapOnMapExtension,
        ListMultimapOnIterableExtension;
export 'src/collection/multimap/set.dart'
    show SetMultimap, SetMultimapOnMapExtension, SetMultimapOnIterableExtension;
export 'src/collection/multiset.dart' show Multiset, MultisetExtension;
export 'src/collection/range.dart' show Range;
export 'src/collection/range/bigint.dart'
    show BigIntRange, BigIntRangeExtension;
export 'src/collection/range/double.dart'
    show DoubleRange, DoubleRangeExtension;
export 'src/collection/range/integer.dart'
    show IntegerRange, IntegerRangeExtension, IndicesIterableExtension;
export 'src/collection/string.dart' show StringExtension;
export 'src/collection/trie.dart'
    show Trie, TrieNode, TrieNodeEntry, TrieNodeList, TrieNodeMap;
export 'src/collection/typemap.dart' show TypeMap;
