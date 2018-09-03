import TruffautSupport

let presentation = Presentation(pages: [

    // intro

    Page(title: "Unicode and You", subtitle: "try? explain(Unicode.self)"),

    Page(title: "Why does this function throw?", contents: [
        .image("images/the-unicode-standard.png"),
        .text("1,044 pages"),
    ]),

    Page(title: "Topics", contents: [
        .text("The Unicode Standard"),
        .text("Cocoa and Unicode"),
        .text("Books and Apps"),
    ]),

    // Unicode Standard

    Page(title: "The Unicode Standard", subtitle: "A Whirlwind Tour"),

    Page(title: "What is Unicode?", contents: [
        .text("A way to represent characters"),
        .text("Multilingual"),
        .text("Character composition"),
        .indent([
            .sourceCode(.plainText, "e(U+0065) + ´(U+00B4) = é(U+00E9)"),
        ]),
        .text("A super set of ASCII"),
    ]),

    Page(title: "Character number and Character name", contents: [
        .text("Every character in Unicode (called a code point) has two unique identifiers:"),
        .indent([
            .text("Character number"),
            .text("Character name"),
        ]),
        .text("Example:"),
        .indent([
            .sourceCode(.plainText, "       Character : é"),
            .sourceCode(.plainText, "Character number : U+00E9 (233 in decimal)"),
            .sourceCode(.plainText, "  Character name : LATIN SMALL LETTER E WITH ACUTE"),
        ]),
    ]),

    Page(title: "Ranges of Character number", contents: [
        .text("Coding space"),
        .indent([
            .sourceCode(.plainText, "U+0000..U+10FFFF"),
            .text("1,114,111 in total"),
        ]),
        .text("Coding space is divided into 17 planes, each has 0xFFFF(65535) of space"),
        .indent([
            .sourceCode(.plainText, "U+0000..U+FFFF"),
            .text("Basic Multilingual Plane (BMP): most used characters"),
            .text(""),
            .sourceCode(.plainText, "U+10000..U+1FFFF"),
            .text("Supplementary Multilingual Plane (SMP): special symbols"),
            .text(""),
            .sourceCode(.plainText, "U+20000..U+2FFFF"),
            .text("Supplementary Ideographic Plane (SIP): less used CJK characters"),
            .text("CJK: Chinese-Japanese-Korean"),
            .text(""),
            .sourceCode(.plainText, "U+30000..U+DFFFF"),
            .text("Unassigned, reserved for future use"),
            .text(""),
            .sourceCode(.plainText, "U+E0000..U+EFFFF"),
            .text("Supplementary Special-Purpose Plane (SSPP): reserved for internal use"),
            .text(""),
            .sourceCode(.plainText, "U+F0000..U+10FFFF"),
            .text("Designed for custom private use"),
            .text(""),
        ]),
    ]),

    Page(title: "UnicodeData.txt", contents: [
        .text("The Unicode database basic file"),
        .text("Example:"),
        .indent([
            .sourceCode(.plainText, "00F6;LATIN SMALL LETTER O WITH DIAERESIS;Ll;0;L;006F 0308;...;00D6;;00D6"),
            .sourceCode(.plainText, "             00F6 - Character number"),
            .sourceCode(.plainText, "LATIN...DIAERESIS - Character name"),
            .sourceCode(.plainText, "               Ll - Letter, lowercase"),
            .sourceCode(.plainText, "        006F 0308 - Canonical decomposition to o(U+006F) +  ̈(U+0308)"),
            .sourceCode(.plainText, "             00D6 - Simple case mapping, uppercase and title case both map to Ö(U+00D6)"),
        ]),
    ]),

    Page(title: "Word boundaries and Line-breaks", contents: [
        .text("Also defined in the Unicode database, e.g.:"),
        .indent([
            .sourceCode(.plainText, "GraphemeBreakProperty.txt"),
            .sourceCode(.plainText, "WordBreakProperty.txt"),
            .sourceCode(.plainText, "SentenceBreakProperty.txt"),
            .sourceCode(.plainText, "LineBreak.txt"),
        ]),
    ]),

    Page(title: "Grapheme cluster", contents: [
        .text("Multiple Unicode code points act as one character"),
        .text("Example:"),
        .indent([
            .sourceCode(.plainText, "é = e´"),
            .sourceCode(.plainText, "Uppercase ß => SS"),
            .sourceCode(.plainText, "🇳🇿 => 🇳 🇿"),
            .indent([
                .sourceCode(.plainText, "U+1F1F3 REGIONAL INDICATOR SYMBOL LETTER N"),
                .sourceCode(.plainText, "U+1F1FF REGIONAL INDICATOR SYMBOL LETTER Z"),
            ]),
            .sourceCode(.plainText, "👨‍👩‍👧‍👦 => 👨U+200D👩U+200D👧U+200D👦"),
            .indent([
                .sourceCode(.plainText, "U+200D ZERO WIDTH JOINER"),
            ]),
        ]),
    ]),

    Page(title: "Unicode encodings: UTF-32", contents: [
        .text("32-bit -> 4 bytes"),
        .text("Unicode number is 21-bit"),
        .indent([
            .text("First 7-bit is plane number"),
            .text("The following 16-bit is the location in the plane"),
        ]),
        .text("32-bit fits"),
        .indent([
            .text("+ Fast encoding and decoding (direct mapping)"),
            .text("+ Random access is O(1)"),
            .text("+ Robust"),
            .text("- Waste of space"),
        ]),
    ]),

    Page(title: "Unicode encodings: UTF-16", contents: [
        .text("BMP (U+0000..U+FFFF): 16-bit -> 2 bytes"),
        .text("Outside BMP (U+1FFFF..U+10FFFF): a pair of 16-bit -> 2 * 2 bytes"),
        .text("Surrogate pair:"),
        .indent([
            .sourceCode(.plainText, "𝐅 U+1D405 MATHEMATICAL BOLD CAPITAL F"),
            .sourceCode(.plainText, "000011101010000000101 // U+1D405 in binary"),
            .sourceCode(.plainText, "u1 = 00001 | u2 = 110101 | u3 = 0000000101"),
            .sourceCode(.plainText, "u1 -= 1"),
            .sourceCode(.plainText, "110110u1u2 = 1101100000110101 // U+D835, high surrogate"),
            .sourceCode(.plainText, "  110111u3 = 1101110000000101 // U+DC05, low surrogate"),
        ]),
        .text("+ BMP encoding and decoding is fast (direct mapping)"),
        .text("+ Robust, high surrogate must always be followed by low surrogate"),
        .text("- Random access is O(n)"),
    ]),

    Page(title: "Unicode encodings: UTF-8", contents: [
        .text("Basic Latin (ASCII) (U+0000..U+007F): 8-bit -> 1 byte"),
        .text("Outside ASCII: up to 32-bit -> up to 4 bytes"),
        .indent([
            .sourceCode(.plainText, "  Code number in binary | Octec 1  Octec 2  Octec 3  Octec 4"),
            .sourceCode(.plainText, "      00000000 0xxxxxxx | 0xxxxxxx"),
            .sourceCode(.plainText, "      00000yyy yyxxxxxx | 110yyyyy 10xxxxxx"),
            .sourceCode(.plainText, "      zzzzyyyy yyxxxxxx | 1110zzzz 10yyyyyy 10xxxxxx"),
            .sourceCode(.plainText, "uuuww zzzzyyyy yyxxxxxx | 11110uuu 10wwzzzz 10yyyyyy 10xxxxxx"),
        ]),
        .text("+ ASCII encoding and decoding is fast (direct mapping) and efficient (1 byte)"),
        .text("+ Robust, bit pattern enforces completeness"),
        .text("- Random access is O(n)"),
    ]),

    Page(title: "URL Encoding, Base64 and Punycode", contents: [
        .text("Emerge because of the World Wide Web"),
        .text("Punycode"),
        .indent([
            .sourceCode(.plainText, "http://👴🏻👀.ws/ -> http://xn--mn8hkeyf.ws/"),
        ]),
        .text("RFCs"),
        .indent([
            .text("URI: RFC 3986"),
            .text("Base64: RFC 3548"),
            .text("Punycode: RFC 3492"),
        ]),
    ]),

    // Cocoa and Unicode

    Page(title: "Cocoa and Unicode", subtitle: "CFStringRef -> NSString -> Swift.String"),

    Page(title: "CFStringRef and NSString", contents: [
        .text("String manipulation APIs are based on UTF-16"),
        .text("Not fully compliant to Unicode"),
        .text("Use with care!!"),
        .indent([
            .sourceCode(.plainText, "import Foundation"),
            .sourceCode(.plainText, "let string = \"👴🏻\" as NSString"),
            .sourceCode(.plainText, "string.length // => 4"),
        ]),
        .text("Cocoa was initially implemented in the late 1990s, UTF-16 was popular by then!"),
    ]),

    Page(title: "Swift.String", contents: [
        .text("Fully compliant to Unicode"),
        .text("Provide APIs to manipulate Unicode scalars"),
        .indent([
            .sourceCode(.plainText, "let string = \"👴🏻\""),
            .sourceCode(.plainText, "string.count // => 1"),
            .sourceCode(.plainText, "string.unicodeScalars // => \u{0001F474} \u{0001F3FB}"),
            .sourceCode(.plainText, "// 👴 U+1F474 OLDER MAN"),
            .sourceCode(.plainText, "// 🏻 U+1F3FB EMOJI MODIFIER FITZPATRICK TYPE-1-2"),
        ]),
    ]),

    // Books and Apps

    Page(title: "Books and Apps", subtitle: "📖 🔨"),

    Page(contents: [
        .image("images/unicode-explained.jpg"),
        .text("Chapter 4, 5, 6"),
    ]),

    Page(contents: [
        .image("images/unicode-checker.png"),
        .text("UnicodeChecker by earthlingsoft"),
    ]),

    Page(title: "Thank you!", subtitle: "@eyeplum"),
])
