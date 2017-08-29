//
//  ReadController.swift
//  Truffaut
//
//  Created by Yan Li on 4/14/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import TruffautSupport

struct ReadController {

    enum ReadingError: Error {
        case unableToLoadSupportModule
        case malformedManifestData(output: String)
    }
    
    static func read(from url: URL, completion: @escaping (Presentation?, Error?) -> Void) {
        ManifestReading.queue.async {
            do {
                let cmd = ManifestReading.command
                let args = try ManifestReading.commandArguments(with: url)
                let output = try Shell.call(command: cmd, arguments: args)
                guard let outputData = output.data(using: .utf8) else {
                    DispatchQueue.main.async {
                        completion(nil, ReadingError.malformedManifestData(output: output))
                    }
                    return
                }
                let presentation = try JSONDecoder().decode(Presentation.self, from: outputData)
                DispatchQueue.main.async {
                    completion(presentation, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
}

import Foundation

fileprivate extension ReadController {
    
    fileprivate struct ManifestReading {
        
        static let queue = DispatchQueue(label: "com.codezerker.truffaut.manifestReading")
        static let command = "/usr/bin/swiftc"
        
        private static let supportModuleName = "TruffautSupport"
        private static var searchPath: String? {
            return Bundle.main.privateFrameworksURL?.appendingPathComponent("\(supportModuleName).framework/Library", isDirectory: true).path
        }
        
        static func commandArguments(with url: URL) throws -> [String] {
            guard let searchPath = searchPath else {
                throw ReadingError.unableToLoadSupportModule
            }
            return [
                /* swiftc settings */
                "--driver-mode=swift",
                "-target", "x86_64-apple-macosx10.13",
                
                /* link options */
                "-I", searchPath,
                "-L", searchPath,
                "-l\(supportModuleName)",
                
                /* manifest file path */
                url.path
            ]
        }
    }
}
