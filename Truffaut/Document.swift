//
//  Document.swift
//  Truffaut
//
//  Created by Yan Li on 4/14/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa
import TruffautSupport

protocol DocumentDataParsing {
    func parse(data: Data) -> [Slides.PageJSON]?
}

class Document: NSDocument {
    
    struct Notifications {
        static let update = "update"
    }
    
    enum ParsingError: Error {
        case InvalidData
    }
    
    var fileNameWithoutExtension: String? {
        return fileURL?.deletingPathExtension().lastPathComponent
    }
    var slides: Slides?
    fileprivate var fileMonitor: FileMonitor?
    fileprivate let manifestReadingQueue = DispatchQueue(label: "com.codezerker.truffaut.manifestReading")
    
    deinit {
        removeFileMonitor()
    }
    
    override class func autosavesInPlace() -> Bool {
        return true
    }
    
    override func makeWindowControllers() {
        let windowController = MainWindowController.loadFromStoryboard()
        addWindowController(windowController)
        
        addFileMonitor()
    }
    
    override func data(ofType typeName: String) throws -> Data {
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        guard let documentURL = fileURL else {
            return
        }
        
        manifestReadingQueue.async {
            let cmd = "/usr/bin/swiftc"
            let supportModule = "TruffautSupport"
            guard let searchPath = Bundle.main.privateFrameworksURL?.appendingPathComponent("\(supportModule).framework/Library", isDirectory: true).path else {
                Swift.print("Unable to load support module, abort.")
                return
            }
            let args = [
                "--driver-mode=swift",
                "-I", searchPath,
                "-L", searchPath,
                "-l\(supportModule)",
                "-target", "x86_64-apple-macosx10.12",
                documentURL.path
            ]
            do {
                let output = try Shell.call(command: cmd, arguments: args)
                Swift.print(output)
                
                guard let outputData = output.data(using: .utf8),
                      let json = try JSONSerialization.jsonObject(with: outputData, options: []) as? JSONDictionary else {
                    Swift.print("Malformed data!")
                    return
                }
                let presentation = Presentation(jsonDictionary: json)
                dump(presentation)
            } catch {
                Swift.print(error)
            }
        }
    }
}

fileprivate extension Document {
    
    fileprivate func addFileMonitor() {
        guard let fileURL = fileURL else {
            return
        }
        
        fileMonitor = FileMonitor(fileURL: fileURL as NSURL) { [weak self] in
            guard let fileURL = self?.fileURL,
                let fileType = self?.fileType else {
                    return
            }
            _ = try? self?.revert(toContentsOf: fileURL, ofType: fileType)
        }
    }
    
    fileprivate func removeFileMonitor() {
        fileMonitor = nil
    }
    
}
