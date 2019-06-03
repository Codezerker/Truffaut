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
            guard let presentation = presentation else {
                let alert: NSAlert

                if let error = error as? ShellRuntimeError {
                    alert = NSAlert()
                    alert.messageText = "Failed to load presentation."
                    switch error {
                    case .brokenPipe:
                        alert.informativeText = "Broken pipe."
                    case .processError(let stderr):
                        alert.informativeText = stderr ?? "Unkown shell error happened when parsing the manifest file."
                    }
                } else if let error = error {
                    alert = NSAlert(error: error)
                } else {
                    alert = NSAlert()
                    alert.messageText = "Failed to load presentation (unexpected error)."
                }
                
                alert.alertStyle = .critical
                alert.showsHelp = true
                alert.delegate = self
                
                if let lastWindow = self.windowControllers.last?.window {
                    alert.beginSheetModal(for: lastWindow, completionHandler: nil)
                } else {
                    alert.runModal()
                }
                
                return
            }
            
            self.presentation = presentation
            completion()
        }
    }
}

extension PresentationDocument: NSAlertDelegate {
    
    static let documentationURLString = "https://github.com/Codezerker/Truffaut/blob/master/Documentations/TruffautSupport-API-Reference.md"
    
    public func alertShowHelp(_ alert: NSAlert) -> Bool {
        if let helpURL = URL(string: PresentationDocument.documentationURLString) {
            NSWorkspace.shared.open(helpURL)
        }
        return true
    }
}
