//
//  UserPreference.swift
//  Truffaut
//
//  Created by Yan Li on 29/12/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Foundation

struct UserPreference {
    
    struct UserDefaultKeys {
        static let customSwiftcPath = "com.codezerker.paths.swiftc"
        static let customRubyPath = "com.codezerker.paths.ruby"
    }
    
    static var customSwiftcPath: String? {
        set {
            guard let newValue = newValue, !newValue.isEmpty else {
                UserDefaults.standard.removeObject(forKey: UserDefaultKeys.customSwiftcPath)
                return
            }
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.customSwiftcPath)
        }
        get {
            guard let customPath = UserDefaults.standard.string(forKey: UserDefaultKeys.customSwiftcPath),
                  !customPath.isEmpty else {
                return nil
            }
            return customPath
        }
    }
    
    static var customRubyPath: String? {
        set {
            guard let newValue = newValue, !newValue.isEmpty else {
                UserDefaults.standard.removeObject(forKey: UserDefaultKeys.customRubyPath)
                return
            }
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.customRubyPath)
        }
        get {
            guard let customPath = UserDefaults.standard.string(forKey: UserDefaultKeys.customRubyPath),
                  !customPath.isEmpty else {
                return nil
            }
            return customPath
        }
    }
}
