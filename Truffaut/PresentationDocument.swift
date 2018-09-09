//
//  Document.swift
//  Truffaut
//
//  Created by Yan Li on 4/14/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa
import TruffautSupport

class PresentationDocument: NSDocument {
    
    enum ParsingError: Error {
        case InvalidData
    }
    
    var fileNameWithoutExtension: String? {
        return fileURL?.deletingPathExtension().lastPathComponent
    }

    var presentation: Presentation?
    
    override class var autosavesInPlace: Bool {
        return true
    }
    
    override func makeWindowControllers() {
        let windowController = MainWindowController.loadFromStoryboard()
        addWindowController(windowController)
    }
    
    override func data(ofType typeName: String) throws -> Data {
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
    
    override func read(from url: URL, ofType typeName: String) throws {
        reload {}
    }
    
    func reload(completion: @escaping () -> Void) {
        guard let url = fileURL else {
            completion()
            return
        }
        
        ReadController.read(from: url) { presentation, error in
            guard let presentation = presentation, error == nil else {
                let alert = NSAlert(error: error!)
                alert.runModal()
                return
            }
            self.presentation = presentation
            
            completion()
        }
    }
}
