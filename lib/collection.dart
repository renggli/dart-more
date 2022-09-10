/// A collection of new collection types: bi-map, bit-list, multi-set, set and
/// list multi-map, range, and string.
export 'src/collection/bimap.dart'
    show BiMap, BiMapOnMapExtension, BiMapOnIterableExtension;
export 'src/collection/bitlist.dart' show BitList, BitListExtension;
export 'src/collection/heap.dart' show Heap;
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
