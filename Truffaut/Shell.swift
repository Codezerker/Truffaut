//
//  Reader.swift
//  Truffaut
//
//  Created by Yan Li on 4/3/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Foundation

public enum ShellRuntimeError: Error {
    case brokenPipe
    case processError(stderr: String?)
}

class Shell: NSObject {
    
    struct Environment {
        
        static var swiftc: String {
            return UserPreference.customSwiftcPath ?? "/usr/bin/swiftc"
        }
        
        static var ruby: String {
            return UserPreference.customRubyPath ?? "/usr/local/bin/ruby"
        }
    }
    
    public static func call(command: String, arguments: [String] = [], currentDirectoryPath: String? = nil) throws -> String {
        let process = Process()
        process.launchPath = command
        process.arguments = arguments
        if let currentDirectoryPath = currentDirectoryPath {
            process.currentDirectoryPath = currentDirectoryPath
        }
        
        let stdout = Pipe()
        let stderr = Pipe()
        process.standardOutput = stdout
        process.standardError = stderr
        
        try process.run()
        process.waitUntilExit()
        
        let stderrData = stderr.fileHandleForReading.readDataToEndOfFile()
        guard stderrData.count == 0 else {
            throw ShellRuntimeError.processError(stderr: String(data: stderrData, encoding: .utf8))
        }
        
        let stdoutData = stdout.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: stdoutData, encoding: .utf8) else {
            throw ShellRuntimeError.brokenPipe
        }
        
        return output
    }
}
