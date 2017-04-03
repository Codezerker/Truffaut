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
        let presentation = Presentation(
            title: "presentation title",
            authors: ["Yan Li <eyeplum@gmail.com>", "@eyeplum"],
            pages: [
                Page(template: "default",
                     title: "hello",
                     subtitle: "say hello",
                     contents: [
                        .bulletPoints([
                            .image("./image/url.png"),
                            .text("hello"),
                        ]),
                     ]),
            ])
        let json = presentation.jsonRepresentation
        guard let newPresentation = Presentation(jsonDictionary: json) else {
            XCTAssert(false)
            return
        }
        
        XCTAssertEqual(presentation.title, newPresentation.title)
        XCTAssertEqual(presentation.authors, newPresentation.authors)
        XCTAssertEqual(presentation.pages.count, newPresentation.pages.count)
        XCTAssertEqual(presentation.pages[0].templateIdentifier, newPresentation.pages[0].templateIdentifier)
        XCTAssertEqual(presentation.pages[0].title, newPresentation.pages[0].title)
        XCTAssertEqual(presentation.pages[0].subtitle, newPresentation.pages[0].subtitle)
        XCTAssertEqual(presentation.pages[0].contents?.count, newPresentation.pages[0].contents?.count)
    }
}
