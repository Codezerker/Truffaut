//
//  MenuActionDispatcher.swift
//  Truffaut
//
//  Created by Yan Li on 4/16/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

struct MenuActionDispatcher {
    
    enum ActionType: Int {
        
        case Previous = 10001
        case Next     = 10002
        case Export   = 10101
        
        var notificationName: String {
            switch self {
            case .Previous:
                return "GotoPrevious"
            case .Next:
                return "GotoNext"
            case .Export:
                return "Export"
            }
        }
        
        func sendNotification() {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationName), object: nil)
        }
    }
    
    // ...
}
