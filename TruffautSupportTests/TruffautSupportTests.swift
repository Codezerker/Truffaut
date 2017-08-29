//
//  TruffautSupportTests.swift
//  TruffautSupportTests
//
//  Created by Yan Li on 4/3/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import XCTest
@testable import TruffautSupport

class TruffautSupportTests: XCTestCase {
    
    func testJSONRepresentation() {
        let sourceCode =
        """
        extension NSAttributedString: _CFBridgeable {
            var _cfObject: CFAttributedString {
                return unsafeBitCast(self, to: CFAttributedString.self)
            }
        }
        """
        
        let presentation = Presentation(
            title: "presentation title",
            authors: ["Yan Li <eyeplum@gmail.com>", "@eyeplum"],
            pages: [
                Page(title: "hello",
                     subtitle: "say hello",
                     contents: [
//                        .indent([
                            .image("./image/url.png"),
                            .text("hello"),
                            .sourceCode(.swift, sourceCode),
//                        ]),
                     ]),
            ])

        guard let data = try? JSONEncoder().encode(presentation),
              let newPresentation = try? JSONDecoder().decode(Presentation.self, from: data) else {
            XCTAssert(false)
            return
        }
        
        XCTAssertEqual(presentation.title, newPresentation.title)
        XCTAssertEqual(presentation.authors, newPresentation.authors)
        XCTAssertEqual(presentation.pages.count, newPresentation.pages.count)
        XCTAssertEqual(presentation.pages[0].title, newPresentation.pages[0].title)
        XCTAssertEqual(presentation.pages[0].subtitle, newPresentation.pages[0].subtitle)
        XCTAssertEqual(presentation.pages[0].contents?.count, newPresentation.pages[0].contents?.count)
        
//        guard let indent = newPresentation.pages[0].contents?.first,
//              case let .indent(contents) = indent else {
//            XCTAssert(false)
//            return
//        }
//        XCTAssertEqual(contents.count, 3)
        
        let contents = presentation.pages[0].contents!

        guard case let .image(path) = contents[0] else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(path, "./image/url.png")
        
        guard case let .text(string) = contents[1] else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(string, "hello")
        
        guard case let .sourceCode(fileType, source) = contents[2] else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(fileType.rawValue, "swift")
        XCTAssertEqual(source, sourceCode)
    }
}
