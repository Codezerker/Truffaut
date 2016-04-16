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
    
    var notificationName: String {
      switch self {
      case .Previous:
        return "GotoPrevious"
      case .Next:
        return "GotoNext"
      }
    }
    
    func sendNotification() {
      NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: nil)
    }
    
    typealias NotificationHandler = (action: ActionType) -> Void
    
    static func registerNotifications(observer observer: AnyObject, handler: NotificationHandler) {
      [ self.Previous,
        self.Next,
      ].map { action in
        return (action.notificationName, action)
      }.forEach { [weak observer] (notificationName, action) in
        NSNotificationCenter.defaultCenter().addObserverForName(
          notificationName,
          object: observer,
          queue: NSOperationQueue.mainQueue(),
          usingBlock: { notification in
            handler(action: action)
          })
      }
    }
  }
  
  static func dispatchAction(menuItem: NSMenuItem) {
    guard let actionType = ActionType(rawValue: menuItem.tag) else {
      return
    }
    
    actionType.sendNotification()
  }
  
}
