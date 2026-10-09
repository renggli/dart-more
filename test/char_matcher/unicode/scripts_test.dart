import 'package:checks/checks.dart';
import 'package:more/char_matcher.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('script', () {
    // A font with wide Unicode coverage such as Unifont
    // (https://www.unifoundry.com/unifont/index.html) is needed to properly
    // display some of these.

    // Group 1
    test('common', () {
      verify(
        UnicodeCharMatcher.scriptCommon(),
        '0123456789!@#_ ',
        'abcABCあ亜ㄅ아אבגابج',
      );
    });
    test('latin', () {
      verify(
        UnicodeCharMatcher.scriptLatin(),
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',
        '012あ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('greek', () {
      verify(
        UnicodeCharMatcher.scriptGreek(),
        'ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξοπρστυφχψω',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('cyrillic', () {
      verify(
        UnicodeCharMatcher.scriptCyrillic(),
        'АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('hebrew', () {
      verify(
        UnicodeCharMatcher.scriptHebrew(),
        'אבגדהוזחטיכלמנסעפצקרשת',
        '012abcABCあ亜ㄅ아_!@# ',
      );
    });
    test('arabic', () {
      verify(
        UnicodeCharMatcher.scriptArabic(),
        'ابتثجحخدذرزسشصضطظعغفقكلمنهوي',
        '012abcABCあ亜ㄅ아_!@# ',
      );
    });
    test('syriac', () {
      verify(
        UnicodeCharMatcher.scriptSyriac(),
        'ܐܒܓܕܗܘܙܚܛܝܟܠܡܢܣܥܦܨ',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('thaana', () {
      verify(
        UnicodeCharMatcher.scriptThaana(),
        'ހށނރބޅކއވމފދތލގޏ',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('devanagari', () {
      verify(
        UnicodeCharMatcher.scriptDevanagari(),
        'अआइईउऊऋऌएऐओऔकखगघङचछजझञटठडढणतथदधनपफबभमयरलवशषसह',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('georgian', () {
      verify(
        UnicodeCharMatcher.scriptGeorgian(),
        'ႠႡႢႣႤႥႦႧႨႩႪႫႬႭႮႯ',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('hangul', () {
      verify(
        UnicodeCharMatcher.scriptHangul(),
        '가나다라마바사아자차카타파하',
        '012abcABCあ亜ㄅאבגابج_!@# ',
      );
    });
    test('ethiopic', () {
      verify(
        UnicodeCharMatcher.scriptEthiopic(),
        'ሀሁሂሃሄህሆለሉሊላሌልሎሏ',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    // Group 2
    test('hiragana', () {
      verify(
        UnicodeCharMatcher.scriptHiragana(),
        'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん',
        '012abcABC亜ㄅ아אבגابج_!@# ',
      );
    });
    test('katakana', () {
      verify(
        UnicodeCharMatcher.scriptKatakana(),
        'アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('han', () {
      verify(
        UnicodeCharMatcher.scriptHan(),
        '漢字中文字語言書寫',
        '012abcABCあㄅ아אבגابج_!@# ',
      );
    });
    test('inherited', () {
      verify(
        UnicodeCharMatcher.scriptInherited(),
        '\u{0300}\u{0301}\u{0345}\u{20e1}\u{101fd}\u{1133b}\u{e0100}',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('tagalog', () {
      verify(
        UnicodeCharMatcher.scriptTagalog(),
        'ᜀᜁᜂᜃᜄᜅᜆᜇᜈᜉᜊᜋᜌᜍᜎᜏ',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('hanunoo', () {
      verify(
        UnicodeCharMatcher.scriptHanunoo(),
        'ᜠᜡᜢᜣᜤᜥᜦᜧᜨᜩᜪᜫᜬᜭᜮᜯ',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('buhid', () {
      verify(
        UnicodeCharMatcher.scriptBuhid(),
        'ᝀᝁᝂᝃᝄᝅᝆᝇᝈᝉᝊᝋᝌᝍᝎᝏ',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('tagbanwa', () {
      verify(
        UnicodeCharMatcher.scriptTagbanwa(),
        'ᝠᝡᝢᝣᝤᝥᝦᝧᝨᝩᝪᝫᝬᝮᝯ',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('braille', () {
      verify(
        UnicodeCharMatcher.scriptBraille(),
        '⠁⠃⠉⠙⠑⠋⠛⠓⠊⠚⠅⠇⠍⠝⠕⠏',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('coptic', () {
      verify(
        UnicodeCharMatcher.scriptCoptic(),
        'ⲀⲂⲄⲆⲈⲊⲌⲎⲐⲒⲔⲖⲘⲚⲜⲞⲠ',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    // Group 3
    test('sudanese', () {
      verify(
        UnicodeCharMatcher.scriptSundanese(),
        'ᮃᮄᮅᮆᮇᮈᮉᮊᮋᮌᮍᮎᮏᮐᮑᮒ',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('lepcha', () {
      verify(
        UnicodeCharMatcher.scriptLepcha(),
        'ᰀᰁᰂᰃᰄᰅᰆᰇᰈᰉᰊᰋᰌᰍᰎᰏ',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('olChiki', () {
      verify(
        UnicodeCharMatcher.scriptOlChiki(),
        'ᱚᱛᱜᱝᱞᱟᱠᱡᱢᱣᱤᱥᱦᱧᱨᱩ',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('saurashtra', () {
      verify(
        UnicodeCharMatcher.scriptSaurashtra(),
        'ꢀꢁꢂꢃꢄꢅꢆꢇꢈꢉꢊꢋꢌꢍꢎꢏ',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('kayahLi', () {
      verify(
        UnicodeCharMatcher.scriptKayahLi(),
        '꤀꤁꤂꤃꤄꤅꤆꤇꤈꤉ꤊꤋꤌꤍꤎꤏ',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    // Group 4
    test('oldNorthArabian', () {
      verify(
        UnicodeCharMatcher.scriptOldNorthArabian(),
        '\u{10A80}\u{10A81}\u{10A82}\u{10A83}\u{10A84}\u{10A85}\u{10A86}\u{10A87}\u{10A88}\u{10A89}',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    test('anatolianHieroglyphs', () {
      verify(
        UnicodeCharMatcher.scriptAnatolianHieroglyphs(),
        '\u{14400}\u{14401}\u{14402}\u{14403}\u{14404}\u{14405}\u{14406}\u{14407}\u{14408}\u{14409}',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    // Group 5
    test('nushu', () {
      verify(
        UnicodeCharMatcher.scriptNushu(),
        '\u{1b170}\u{1b171}\u{1b172}\u{1b180}\u{1b1c0}\u{1b2fb}',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    // Group 6
    test('unknown', () {
      verify(
        UnicodeCharMatcher.scriptUnknown(),
        '\u{0378}\u{0380}\u{0558}\u{191f}\u{dead}\u{deaf}\u{eeee}\u{ffff}\u{1000c}\u{10fddd}\u{10fffd}',
        '012abcABCあ亜ㄅ아אבגابج_!@# ',
      );
    });
    // Verify that each script is in exactly one class, or unknown.
    test('distinct', () {
      final scripts = [
        UnicodeCharMatcher.scriptCommon(),
        UnicodeCharMatcher.scriptLatin(),
        UnicodeCharMatcher.scriptGreek(),
        UnicodeCharMatcher.scriptCyrillic(),
        UnicodeCharMatcher.scriptArmenian(),
        UnicodeCharMatcher.scriptHebrew(),
        UnicodeCharMatcher.scriptArabic(),
        UnicodeCharMatcher.scriptSyriac(),
        UnicodeCharMatcher.scriptThaana(),
        UnicodeCharMatcher.scriptDevanagari(),
        UnicodeCharMatcher.scriptBengali(),
        UnicodeCharMatcher.scriptGurmukhi(),
        UnicodeCharMatcher.scriptGujarati(),
        UnicodeCharMatcher.scriptOriya(),
        UnicodeCharMatcher.scriptTamil(),
        UnicodeCharMatcher.scriptTelugu(),
        UnicodeCharMatcher.scriptKannada(),
        UnicodeCharMatcher.scriptMalayalam(),
        UnicodeCharMatcher.scriptSinhala(),
        UnicodeCharMatcher.scriptThai(),
        UnicodeCharMatcher.scriptLao(),
        UnicodeCharMatcher.scriptTibetan(),
        UnicodeCharMatcher.scriptMyanmar(),
        UnicodeCharMatcher.scriptGeorgian(),
        UnicodeCharMatcher.scriptHangul(),
        UnicodeCharMatcher.scriptEthiopic(),
        UnicodeCharMatcher.scriptCherokee(),
        UnicodeCharMatcher.scriptCanadianAboriginal(),
        UnicodeCharMatcher.scriptOgham(),
        UnicodeCharMatcher.scriptRunic(),
        UnicodeCharMatcher.scriptKhmer(),
        UnicodeCharMatcher.scriptMongolian(),
        UnicodeCharMatcher.scriptHiragana(),
        UnicodeCharMatcher.scriptKatakana(),
        UnicodeCharMatcher.scriptBopomofo(),
        UnicodeCharMatcher.scriptHan(),
        UnicodeCharMatcher.scriptYi(),
        UnicodeCharMatcher.scriptOldItalic(),
        UnicodeCharMatcher.scriptGothic(),
        UnicodeCharMatcher.scriptDeseret(),
        UnicodeCharMatcher.scriptInherited(),
        UnicodeCharMatcher.scriptTagalog(),
        UnicodeCharMatcher.scriptHanunoo(),
        UnicodeCharMatcher.scriptBuhid(),
        UnicodeCharMatcher.scriptTagbanwa(),
        UnicodeCharMatcher.scriptLimbu(),
        UnicodeCharMatcher.scriptTaiLe(),
        UnicodeCharMatcher.scriptLinearB(),
        UnicodeCharMatcher.scriptUgaritic(),
        UnicodeCharMatcher.scriptShavian(),
        UnicodeCharMatcher.scriptOsmanya(),
        UnicodeCharMatcher.scriptCypriot(),
        UnicodeCharMatcher.scriptBraille(),
        UnicodeCharMatcher.scriptBuginese(),
        UnicodeCharMatcher.scriptCoptic(),
        UnicodeCharMatcher.scriptNewTaiLue(),
        UnicodeCharMatcher.scriptGlagolitic(),
        UnicodeCharMatcher.scriptTifinagh(),
        UnicodeCharMatcher.scriptSylotiNagri(),
        UnicodeCharMatcher.scriptOldPersian(),
        UnicodeCharMatcher.scriptKharoshthi(),
        UnicodeCharMatcher.scriptBalinese(),
        UnicodeCharMatcher.scriptCuneiform(),
        UnicodeCharMatcher.scriptPhoenician(),
        UnicodeCharMatcher.scriptPhagsPa(),
        UnicodeCharMatcher.scriptNko(),
        UnicodeCharMatcher.scriptSundanese(),
        UnicodeCharMatcher.scriptLepcha(),
        UnicodeCharMatcher.scriptOlChiki(),
        UnicodeCharMatcher.scriptVai(),
        UnicodeCharMatcher.scriptSaurashtra(),
        UnicodeCharMatcher.scriptKayahLi(),
        UnicodeCharMatcher.scriptRejang(),
        UnicodeCharMatcher.scriptLycian(),
        UnicodeCharMatcher.scriptCarian(),
        UnicodeCharMatcher.scriptLydian(),
        UnicodeCharMatcher.scriptCham(),
        UnicodeCharMatcher.scriptTaiTham(),
        UnicodeCharMatcher.scriptTaiViet(),
        UnicodeCharMatcher.scriptAvestan(),
        UnicodeCharMatcher.scriptEgyptianHieroglyphs(),
        UnicodeCharMatcher.scriptSamaritan(),
        UnicodeCharMatcher.scriptLisu(),
        UnicodeCharMatcher.scriptBamum(),
        UnicodeCharMatcher.scriptJavanese(),
        UnicodeCharMatcher.scriptMeeteiMayek(),
        UnicodeCharMatcher.scriptImperialAramaic(),
        UnicodeCharMatcher.scriptOldSouthArabian(),
        UnicodeCharMatcher.scriptInscriptionalParthian(),
        UnicodeCharMatcher.scriptInscriptionalPahlavi(),
        UnicodeCharMatcher.scriptOldTurkic(),
        UnicodeCharMatcher.scriptKaithi(),
        UnicodeCharMatcher.scriptBatak(),
        UnicodeCharMatcher.scriptBrahmi(),
        UnicodeCharMatcher.scriptMandaic(),
        UnicodeCharMatcher.scriptChakma(),
        UnicodeCharMatcher.scriptMeroiticCursive(),
        UnicodeCharMatcher.scriptMeroiticHieroglyphs(),
        UnicodeCharMatcher.scriptMiao(),
        UnicodeCharMatcher.scriptSharada(),
        UnicodeCharMatcher.scriptSoraSompeng(),
        UnicodeCharMatcher.scriptTakri(),
        UnicodeCharMatcher.scriptCaucasianAlbanian(),
        UnicodeCharMatcher.scriptBassaVah(),
        UnicodeCharMatcher.scriptDuployan(),
        UnicodeCharMatcher.scriptElbasan(),
        UnicodeCharMatcher.scriptGrantha(),
        UnicodeCharMatcher.scriptPahawhHmong(),
        UnicodeCharMatcher.scriptKhojki(),
        UnicodeCharMatcher.scriptLinearA(),
        UnicodeCharMatcher.scriptMahajani(),
        UnicodeCharMatcher.scriptManichaean(),
        UnicodeCharMatcher.scriptMendeKikakui(),
        UnicodeCharMatcher.scriptModi(),
        UnicodeCharMatcher.scriptMro(),
        UnicodeCharMatcher.scriptOldNorthArabian(),
        UnicodeCharMatcher.scriptNabataean(),
        UnicodeCharMatcher.scriptPalmyrene(),
        UnicodeCharMatcher.scriptPauCinHau(),
        UnicodeCharMatcher.scriptOldPermic(),
        UnicodeCharMatcher.scriptPsalterPahlavi(),
        UnicodeCharMatcher.scriptSiddham(),
        UnicodeCharMatcher.scriptKhudawadi(),
        UnicodeCharMatcher.scriptTirhuta(),
        UnicodeCharMatcher.scriptWarangCiti(),
        UnicodeCharMatcher.scriptAhom(),
        UnicodeCharMatcher.scriptAnatolianHieroglyphs(),
        UnicodeCharMatcher.scriptHatran(),
        UnicodeCharMatcher.scriptMultani(),
        UnicodeCharMatcher.scriptOldHungarian(),
        UnicodeCharMatcher.scriptSignwriting(),
        UnicodeCharMatcher.scriptAdlam(),
        UnicodeCharMatcher.scriptBhaiksuki(),
        UnicodeCharMatcher.scriptMarchen(),
        UnicodeCharMatcher.scriptNewa(),
        UnicodeCharMatcher.scriptOsage(),
        UnicodeCharMatcher.scriptTangut(),
        UnicodeCharMatcher.scriptMasaramGondi(),
        UnicodeCharMatcher.scriptNushu(),
        UnicodeCharMatcher.scriptSoyombo(),
        UnicodeCharMatcher.scriptZanabazarSquare(),
        UnicodeCharMatcher.scriptDogra(),
        UnicodeCharMatcher.scriptGunjalaGondi(),
        UnicodeCharMatcher.scriptMakasar(),
        UnicodeCharMatcher.scriptMedefaidrin(),
        UnicodeCharMatcher.scriptHanifiRohingya(),
        UnicodeCharMatcher.scriptSogdian(),
        UnicodeCharMatcher.scriptOldSogdian(),
        UnicodeCharMatcher.scriptElymaic(),
        UnicodeCharMatcher.scriptNandinagari(),
        UnicodeCharMatcher.scriptNyiakengPuachueHmong(),
        UnicodeCharMatcher.scriptWancho(),
        UnicodeCharMatcher.scriptChorasmian(),
        UnicodeCharMatcher.scriptDivesAkuru(),
        UnicodeCharMatcher.scriptKhitanSmallScript(),
        UnicodeCharMatcher.scriptYezidi(),
        UnicodeCharMatcher.scriptCyproMinoan(),
        UnicodeCharMatcher.scriptOldUyghur(),
        UnicodeCharMatcher.scriptTangsa(),
        UnicodeCharMatcher.scriptToto(),
        UnicodeCharMatcher.scriptVithkuqi(),
        UnicodeCharMatcher.scriptKawi(),
        UnicodeCharMatcher.scriptNagMundari(),
        UnicodeCharMatcher.scriptGaray(),
        UnicodeCharMatcher.scriptGurungKhema(),
        UnicodeCharMatcher.scriptKiratRai(),
        UnicodeCharMatcher.scriptOlOnal(),
        UnicodeCharMatcher.scriptSunuwar(),
        UnicodeCharMatcher.scriptTodhri(),
        UnicodeCharMatcher.scriptTuluTigalari(),
        UnicodeCharMatcher.scriptSidetic(),
        UnicodeCharMatcher.scriptTaiYo(),
        UnicodeCharMatcher.scriptTolongSiki(),
        UnicodeCharMatcher.scriptBeriaErfe(),
        UnicodeCharMatcher.scriptUnknown(),
      ];
      for (var charCode = 0; charCode <= 0x10ffff; charCode++) {
        final matches = scripts.count((script) => script.match(charCode));
        check(
          matches,
          because: '$charCode is in $matches script classes',
        ).equals(1);
      }
    });
  });
}
