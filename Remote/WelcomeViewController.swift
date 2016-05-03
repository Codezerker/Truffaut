//
//  ViewController.swift
//  Remote
//
//  Created by Yan Li on 5/3/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import UIKit
import MultipeerConnectivity

struct Service {
  static let session = MCSession(peer: MCPeerID(displayName: "Remote: \(UIDevice.currentDevice().name)"))
  static let type = "truffaut-remote"
}

class WelcomeViewController: UIViewController {
  
  @IBAction func searchTapped() {
    let browserViewController = MCBrowserViewController(serviceType: Service.type, session: Service.session)
    browserViewController.delegate = self
    presentViewController(browserViewController, animated: true, completion: nil)
  }

}

extension WelcomeViewController: MCBrowserViewControllerDelegate {
  
  func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
    print(#function)
  }
  
  func browserViewController(browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
    print("\(#function): \(peerID) - \(info)")
    
    return true
  }
  
}

