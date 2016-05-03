//
//  ViewController.swift
//  Remote
//
//  Created by Yan Li on 5/3/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import UIKit
import MultipeerConnectivity

final class WelcomeViewController: UIViewController {
  
  @IBOutlet private weak var addButton: UIBarButtonItem!
  @IBOutlet private weak var previousButton: UIButton!
  @IBOutlet private weak var nextButton: UIButton!
  
  private let remoteSession: MCSession = {
    let peerID = MCPeerID(displayName: "Remote: \(UIDevice.currentDevice().name)")
    return MCSession(peer: peerID)
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupButtons(false)
    remoteSession.delegate = self
  }

  private func setupButtons(connected: Bool) {
    addButton.enabled = !connected
    
    previousButton.enabled = connected
    nextButton.enabled = connected
  }
  
}

extension WelcomeViewController: MCSessionDelegate {
  
  func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
    switch state {
    case .NotConnected, .Connecting:
      setupButtons(false)
    case .Connected:
      setupButtons(true)
    }
  }
  
  func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
    // ...
  }
  
  func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    // ...
  }
  
  func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
    // ...
  }
  
  func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
    // ...
  }
  
}

extension WelcomeViewController {
  
  @IBAction func searchTapped() {
    let browserViewController = MCBrowserViewController(serviceType: RemoteProtocol.serviceType, session: remoteSession)
    browserViewController.delegate = self
    presentViewController(browserViewController, animated: true, completion: nil)
  }
  
  @IBAction func previousTapped() {
    do {
      try remoteSession.sendData(
        RemoteProtocol.Command.Previous.dataRepresentation(),
        toPeers: remoteSession.connectedPeers,
        withMode: .Reliable)
    } catch {
      print(error)
    }
  }
  
  @IBAction func nextTapped() {
    do {
      try remoteSession.sendData(
        RemoteProtocol.Command.Next.dataRepresentation(),
        toPeers: remoteSession.connectedPeers,
        withMode: .Reliable)
    } catch {
      print(error)
    }
  }
  
}

extension WelcomeViewController: MCBrowserViewControllerDelegate {
  
  func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func browserViewController(browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
    print("\(#function): \(peerID) - \(info)")
    return true
  }
  
}

