//
//  ViewController.swift
//  Remote
//
//  Created by Yan Li on 5/3/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class WelcomeViewController: UIViewController {
  
  let remoteSession: MCSession = {
    let peerID = MCPeerID(displayName: "Remote: \(UIDevice.currentDevice().name)")
    return MCSession(peer: peerID)
  }()
  
  @IBAction func searchTapped() {
    let browserViewController = MCBrowserViewController(serviceType: RemoteProtocol.serviceType, session: remoteSession)
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

