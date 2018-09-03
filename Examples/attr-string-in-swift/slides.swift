let cfAttrStrDef = """
struct __CFAttributedString {
    CFRuntimeBase base;
    CFStringRef string;
    CFRunArrayRef attributeArray;
};
"""

let cfAttrStrClassDef = """
static const CFRuntimeClass __CFAttributedStringClass = {
    0,
    "CFAttributedString",
    NULL,	// init
    NULL,	// copy
    __CFAttributedStringDeallocate,
    __CFAttributedStringEqual, // <----- THIS!!
    __CFAttributedStringHash,
    NULL,
    __CFAttributedStringCopyDescription
};
"""

let copyIsRetain = """
// NSAttributedString

open override func copy() -> Any {
    return copy(with: nil)
}

open func copy(with zone: NSZone? = nil) -> Any {
    return self
}

// NSMutableAttributedString

open override func copy(with zone: NSZone? = nil) -> Any {
    return NSAttributedString(attributedString: self)
}
"""

import TruffautSupport

let presentation = Presentation(pages: [

    Page(title: "NSAttributedString.swift",
         subtitle: "A implementation story"),

    Page(title: "swift-corelibs-foundation", contents: [
        .text("A Swift re-implementation of Foundation.framework"),
        .text("For platforms without Objective-C runtime"),
        .text("Interface matching DarwinFoundation"),
        .text("Implementation unrelated"),
    ]),

    Page(title: "CoreFoundation", contents: [
        .text("C library, Foundation's \"core\""),
        .text("Provides common data types for all frameworks (Darwin)"),
        .text("Toll-free bridging"),
        .indent([
            .text("Bridgable: NSString is-a CFStringRef"),
            .text("Non-bridgable: NSRunLoop has-a CFRunLoop"),
        ]),
    ]),

    Page(title: "CFAttributedString.c", contents: [
        .text("CFAttributedString and CFMutableAttributedString are the same"),
        .sourceCode(.c, cfAttrStrDef),
    ]),

    Page(title: "_CFInfo", contents: [
        .text("Essentially 64 bit of in-memory data"),
        .text("Type meta data of all CFTypes"),
        .indent([
            .text("Is this CFTypeRef a __CFAttributedString?"),
            .text("Is this __CFAttributedString mutable?"),
        ]),
    ]),

    Page(title: "class NSAttributedString {}", contents: [
        .text("It's a string"),
        .indent([
            .sourceCode(.swift, "var _string: NSString"),
        ]),
        .text("It has attributes"),
        .indent([
            .sourceCode(.swift, "var _attributes: CFRunArray"),
            .text("The \"Run\" is the same as in \"CTRunRef\""),
        ]),
        .text("It is-a CFAttributedStringRef"),
        .indent([
            .sourceCode(.swift, "let _cfinfo: _CFInfo"),
        ]),
    ]),

    Page(title: "init(...)", contents: [
        .sourceCode(.swift,     "self = CFAttributedStringCreate(...)"),
        .sourceCode(.plainText, "~~~~ ^ error: cannot assign to value: 'self' is immutable"),
        .text("We need to re-implement CFAttributedStringCreate(...) in Swift!"),
    ]),

    Page(title: "func attribute(...)", contents: [
        .sourceCode(.swift, "typealias NSRangePointer = UnsafeMutablePointer<NSRange>"),
        .text("Time for a pointer dance!"),
    ]),

    Page(title: "func enumerateAttributes(...)", contents: [
        .text("A peek of DarwinFoundation"),
        .text("So excited!!"),
        .text("Remember the implementation!"),
        .text("Annnnnnd, the code is messy :troll:"),
    ]),

    Page(title: "class NSMutableAttributedString: NSAttributedString {}", contents: [
        .sourceCode(.swift, "var mutableString: NSMutableString"),
        .text("It is-a CFMutableAttributedString"),
    ]),

    Page(title: "func isEqual(to:)", contents: [
        .sourceCode(.c, cfAttrStrClassDef),
    ]),

    Page(title: "NSCopying", contents: [
        .text("You say copy, I say retain."),
        .sourceCode(.swift, copyIsRetain),
    ]),

    Page(title: "What's NeXT", contents: [
        .text("Make some swift packages to use NS[Mutable]AttributedString"),
        .sourceCode(.swift, "let string = \"hello\" as NSString"),
        .text("5 non-trivial pull requests -> commit access!")
    ]),

    Page(title: "NSAttributedString(string: \"Thanks!\")"),
])
