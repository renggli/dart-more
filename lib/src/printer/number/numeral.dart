// AUTO-GENERATED CODE: DO NOT EDIT

// https://www.unicode.org/Public/18.0.0/ucd/UnicodeData.txt

/// A class defining different numeral systems for number printing.
///
/// To remain customizable the number systems are provided through immutable
/// `List<String>` instances. Each list starts with the string representations
/// for 0, 1, 2, ... up to the maximally supported base.
///
/// The default number system is [latin].
abstract class NumeralSystem {
  static const latin = lowerCaseLatin;
  static const lowerCaseLatin = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
  ];
  static const upperCaseLatin = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  static const arabicIndic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  static const extendedArabicIndic = [
    '۰',
    '۱',
    '۲',
    '۳',
    '۴',
    '۵',
    '۶',
    '۷',
    '۸',
    '۹',
  ];
  static const nko = ['߀', '߁', '߂', '߃', '߄', '߅', '߆', '߇', '߈', '߉'];
  static const devanagari = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
  static const bengali = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  static const gurmukhi = ['੦', '੧', '੨', '੩', '੪', '੫', '੬', '੭', '੮', '੯'];
  static const gujarati = ['૦', '૧', '૨', '૩', '૪', '૫', '૬', '૭', '૮', '૯'];
  static const oriya = ['୦', '୧', '୨', '୩', '୪', '୫', '୬', '୭', '୮', '୯'];
  static const tamil = ['௦', '௧', '௨', '௩', '௪', '௫', '௬', '௭', '௮', '௯'];
  static const telugu = ['౦', '౧', '౨', '౩', '౪', '౫', '౬', '౭', '౮', '౯'];
  static const kannada = ['೦', '೧', '೨', '೩', '೪', '೫', '೬', '೭', '೮', '೯'];
  static const malayalam = ['൦', '൧', '൨', '൩', '൪', '൫', '൬', '൭', '൮', '൯'];
  static const sinhalaLith = ['෦', '෧', '෨', '෩', '෪', '෫', '෬', '෭', '෮', '෯'];
  static const thai = ['๐', '๑', '๒', '๓', '๔', '๕', '๖', '๗', '๘', '๙'];
  static const lao = ['໐', '໑', '໒', '໓', '໔', '໕', '໖', '໗', '໘', '໙'];
  static const tibetan = ['༠', '༡', '༢', '༣', '༤', '༥', '༦', '༧', '༨', '༩'];
  static const myanmar = ['၀', '၁', '၂', '၃', '၄', '၅', '၆', '၇', '၈', '၉'];
  static const myanmarShan = ['႐', '႑', '႒', '႓', '႔', '႕', '႖', '႗', '႘', '႙'];
  static const khmer = ['០', '១', '២', '៣', '៤', '៥', '៦', '៧', '៨', '៩'];
  static const mongolian = ['᠐', '᠑', '᠒', '᠓', '᠔', '᠕', '᠖', '᠗', '᠘', '᠙'];
  static const limbu = ['᥆', '᥇', '᥈', '᥉', '᥊', '᥋', '᥌', '᥍', '᥎', '᥏'];
  static const newTaiLue = ['᧐', '᧑', '᧒', '᧓', '᧔', '᧕', '᧖', '᧗', '᧘', '᧙'];
  static const taiThamHora = ['᪀', '᪁', '᪂', '᪃', '᪄', '᪅', '᪆', '᪇', '᪈', '᪉'];
  static const taiThamTham = ['᪐', '᪑', '᪒', '᪓', '᪔', '᪕', '᪖', '᪗', '᪘', '᪙'];
  static const balinese = ['᭐', '᭑', '᭒', '᭓', '᭔', '᭕', '᭖', '᭗', '᭘', '᭙'];
  static const sundanese = ['᮰', '᮱', '᮲', '᮳', '᮴', '᮵', '᮶', '᮷', '᮸', '᮹'];
  static const lepcha = ['᱀', '᱁', '᱂', '᱃', '᱄', '᱅', '᱆', '᱇', '᱈', '᱉'];
  static const olChiki = ['᱐', '᱑', '᱒', '᱓', '᱔', '᱕', '᱖', '᱗', '᱘', '᱙'];
  static const vai = ['꘠', '꘡', '꘢', '꘣', '꘤', '꘥', '꘦', '꘧', '꘨', '꘩'];
  static const saurashtra = ['꣐', '꣑', '꣒', '꣓', '꣔', '꣕', '꣖', '꣗', '꣘', '꣙'];
  static const kayahLi = ['꤀', '꤁', '꤂', '꤃', '꤄', '꤅', '꤆', '꤇', '꤈', '꤉'];
  static const javanese = ['꧐', '꧑', '꧒', '꧓', '꧔', '꧕', '꧖', '꧗', '꧘', '꧙'];
  static const myanmarTaiLaing = [
    '꧰',
    '꧱',
    '꧲',
    '꧳',
    '꧴',
    '꧵',
    '꧶',
    '꧷',
    '꧸',
    '꧹',
  ];
  static const cham = ['꩐', '꩑', '꩒', '꩓', '꩔', '꩕', '꩖', '꩗', '꩘', '꩙'];
  static const meeteiMayek = ['꯰', '꯱', '꯲', '꯳', '꯴', '꯵', '꯶', '꯷', '꯸', '꯹'];
  static const fullwidth = ['０', '１', '２', '３', '４', '５', '６', '７', '８', '９'];
  static const osmanya = [
    '𐒠',
    '𐒡',
    '𐒢',
    '𐒣',
    '𐒤',
    '𐒥',
    '𐒦',
    '𐒧',
    '𐒨',
    '𐒩',
  ];
  static const hanifiRohingya = [
    '𐴰',
    '𐴱',
    '𐴲',
    '𐴳',
    '𐴴',
    '𐴵',
    '𐴶',
    '𐴷',
    '𐴸',
    '𐴹',
  ];
  static const garay = [
    '𐵀',
    '𐵁',
    '𐵂',
    '𐵃',
    '𐵄',
    '𐵅',
    '𐵆',
    '𐵇',
    '𐵈',
    '𐵉',
  ];
  static const brahmi = [
    '𑁦',
    '𑁧',
    '𑁨',
    '𑁩',
    '𑁪',
    '𑁫',
    '𑁬',
    '𑁭',
    '𑁮',
    '𑁯',
  ];
  static const soraSompeng = [
    '𑃰',
    '𑃱',
    '𑃲',
    '𑃳',
    '𑃴',
    '𑃵',
    '𑃶',
    '𑃷',
    '𑃸',
    '𑃹',
  ];
  static const chakma = [
    '𑄶',
    '𑄷',
    '𑄸',
    '𑄹',
    '𑄺',
    '𑄻',
    '𑄼',
    '𑄽',
    '𑄾',
    '𑄿',
  ];
  static const sharada = [
    '𑇐',
    '𑇑',
    '𑇒',
    '𑇓',
    '𑇔',
    '𑇕',
    '𑇖',
    '𑇗',
    '𑇘',
    '𑇙',
  ];
  static const khudawadi = [
    '𑋰',
    '𑋱',
    '𑋲',
    '𑋳',
    '𑋴',
    '𑋵',
    '𑋶',
    '𑋷',
    '𑋸',
    '𑋹',
  ];
  static const newa = [
    '𑑐',
    '𑑑',
    '𑑒',
    '𑑓',
    '𑑔',
    '𑑕',
    '𑑖',
    '𑑗',
    '𑑘',
    '𑑙',
  ];
  static const tirhuta = [
    '𑓐',
    '𑓑',
    '𑓒',
    '𑓓',
    '𑓔',
    '𑓕',
    '𑓖',
    '𑓗',
    '𑓘',
    '𑓙',
  ];
  static const modi = [
    '𑙐',
    '𑙑',
    '𑙒',
    '𑙓',
    '𑙔',
    '𑙕',
    '𑙖',
    '𑙗',
    '𑙘',
    '𑙙',
  ];
  static const takri = [
    '𑛀',
    '𑛁',
    '𑛂',
    '𑛃',
    '𑛄',
    '𑛅',
    '𑛆',
    '𑛇',
    '𑛈',
    '𑛉',
  ];
  static const myanmarPao = [
    '𑛐',
    '𑛑',
    '𑛒',
    '𑛓',
    '𑛔',
    '𑛕',
    '𑛖',
    '𑛗',
    '𑛘',
    '𑛙',
  ];
  static const myanmarEasternPwoKaren = [
    '𑛚',
    '𑛛',
    '𑛜',
    '𑛝',
    '𑛞',
    '𑛟',
    '𑛠',
    '𑛡',
    '𑛢',
    '𑛣',
  ];
  static const ahom = [
    '𑜰',
    '𑜱',
    '𑜲',
    '𑜳',
    '𑜴',
    '𑜵',
    '𑜶',
    '𑜷',
    '𑜸',
    '𑜹',
  ];
  static const warangCiti = [
    '𑣠',
    '𑣡',
    '𑣢',
    '𑣣',
    '𑣤',
    '𑣥',
    '𑣦',
    '𑣧',
    '𑣨',
    '𑣩',
  ];
  static const divesAkuru = [
    '𑥐',
    '𑥑',
    '𑥒',
    '𑥓',
    '𑥔',
    '𑥕',
    '𑥖',
    '𑥗',
    '𑥘',
    '𑥙',
  ];
  static const sunuwar = [
    '𑯰',
    '𑯱',
    '𑯲',
    '𑯳',
    '𑯴',
    '𑯵',
    '𑯶',
    '𑯷',
    '𑯸',
    '𑯹',
  ];
  static const bhaiksuki = [
    '𑱐',
    '𑱑',
    '𑱒',
    '𑱓',
    '𑱔',
    '𑱕',
    '𑱖',
    '𑱗',
    '𑱘',
    '𑱙',
  ];
  static const masaramGondi = [
    '𑵐',
    '𑵑',
    '𑵒',
    '𑵓',
    '𑵔',
    '𑵕',
    '𑵖',
    '𑵗',
    '𑵘',
    '𑵙',
  ];
  static const gunjalaGondi = [
    '𑶠',
    '𑶡',
    '𑶢',
    '𑶣',
    '𑶤',
    '𑶥',
    '𑶦',
    '𑶧',
    '𑶨',
    '𑶩',
  ];
  static const tolongSiki = [
    '𑷠',
    '𑷡',
    '𑷢',
    '𑷣',
    '𑷤',
    '𑷥',
    '𑷦',
    '𑷧',
    '𑷨',
    '𑷩',
  ];
  static const kawi = [
    '𑽐',
    '𑽑',
    '𑽒',
    '𑽓',
    '𑽔',
    '𑽕',
    '𑽖',
    '𑽗',
    '𑽘',
    '𑽙',
  ];
  static const gurungKhema = [
    '𖄰',
    '𖄱',
    '𖄲',
    '𖄳',
    '𖄴',
    '𖄵',
    '𖄶',
    '𖄷',
    '𖄸',
    '𖄹',
  ];
  static const mro = [
    '𖩠',
    '𖩡',
    '𖩢',
    '𖩣',
    '𖩤',
    '𖩥',
    '𖩦',
    '𖩧',
    '𖩨',
    '𖩩',
  ];
  static const tangsa = [
    '𖫀',
    '𖫁',
    '𖫂',
    '𖫃',
    '𖫄',
    '𖫅',
    '𖫆',
    '𖫇',
    '𖫈',
    '𖫉',
  ];
  static const pahawhHmong = [
    '𖭐',
    '𖭑',
    '𖭒',
    '𖭓',
    '𖭔',
    '𖭕',
    '𖭖',
    '𖭗',
    '𖭘',
    '𖭙',
  ];
  static const kiratRai = [
    '𖵰',
    '𖵱',
    '𖵲',
    '𖵳',
    '𖵴',
    '𖵵',
    '𖵶',
    '𖵷',
    '𖵸',
    '𖵹',
  ];
  static const outlined = [
    '𜳰',
    '𜳱',
    '𜳲',
    '𜳳',
    '𜳴',
    '𜳵',
    '𜳶',
    '𜳷',
    '𜳸',
    '𜳹',
  ];
  static const mathematicalBold = [
    '𝟎',
    '𝟏',
    '𝟐',
    '𝟑',
    '𝟒',
    '𝟓',
    '𝟔',
    '𝟕',
    '𝟖',
    '𝟗',
  ];
  static const mathematicalDoubleStruck = [
    '𝟘',
    '𝟙',
    '𝟚',
    '𝟛',
    '𝟜',
    '𝟝',
    '𝟞',
    '𝟟',
    '𝟠',
    '𝟡',
  ];
  static const mathematicalSansSerif = [
    '𝟢',
    '𝟣',
    '𝟤',
    '𝟥',
    '𝟦',
    '𝟧',
    '𝟨',
    '𝟩',
    '𝟪',
    '𝟫',
  ];
  static const mathematicalSansSerifBold = [
    '𝟬',
    '𝟭',
    '𝟮',
    '𝟯',
    '𝟰',
    '𝟱',
    '𝟲',
    '𝟳',
    '𝟴',
    '𝟵',
  ];
  static const mathematicalMonospace = [
    '𝟶',
    '𝟷',
    '𝟸',
    '𝟹',
    '𝟺',
    '𝟻',
    '𝟼',
    '𝟽',
    '𝟾',
    '𝟿',
  ];
  static const nyiakengPuachueHmong = [
    '𞅀',
    '𞅁',
    '𞅂',
    '𞅃',
    '𞅄',
    '𞅅',
    '𞅆',
    '𞅇',
    '𞅈',
    '𞅉',
  ];
  static const wancho = [
    '𞋰',
    '𞋱',
    '𞋲',
    '𞋳',
    '𞋴',
    '𞋵',
    '𞋶',
    '𞋷',
    '𞋸',
    '𞋹',
  ];
  static const nagMundari = [
    '𞓰',
    '𞓱',
    '𞓲',
    '𞓳',
    '𞓴',
    '𞓵',
    '𞓶',
    '𞓷',
    '𞓸',
    '𞓹',
  ];
  static const olOnal = [
    '𞗱',
    '𞗲',
    '𞗳',
    '𞗴',
    '𞗵',
    '𞗶',
    '𞗷',
    '𞗸',
    '𞗹',
    '𞗺',
  ];
  static const adlam = [
    '𞥐',
    '𞥑',
    '𞥒',
    '𞥓',
    '𞥔',
    '𞥕',
    '𞥖',
    '𞥗',
    '𞥘',
    '𞥙',
  ];
  static const segmented = [
    '🯰',
    '🯱',
    '🯲',
    '🯳',
    '🯴',
    '🯵',
    '🯶',
    '🯷',
    '🯸',
    '🯹',
  ];
}
