//
//  RemoteService.swift
//  Truffaut
//
//  Created by Yan Li on 5/3/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Foundation
import MultipeerConnectivity

final class RemoteServer: NSObject {
  
  static let sharedServer = RemoteServer()
  
  private var advertiser: MCNearbyServiceAdvertiser?
  private var connectedSession: MCSession?
  
  func start() {
    guard self.advertiser == nil else {
      return
    }
    
    let displayName = "Truffaut on \"\(NSHost.currentHost().localizedName ?? "Unknown Device")\""
    let peerID = MCPeerID(displayName: displayName)
    let advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: RemoteProtocol.serviceType)
    advertiser.delegate = self
    advertiser.startAdvertisingPeer()
    
    self.advertiser = advertiser
  }
  
}

extension RemoteServer: MCSessionDelegate {
  
  func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
    print("\(#function) \(peerID) - \(state.rawValue)")
    
    switch state {
    case MCSessionState.NotConnected:
      connectedSession = nil
    default:
      break
    }
  }
  
  func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
    print("\(#function) \(data.length) - \(peerID)")
    
    guard let command = RemoteProtocol.Command(data: data) else {
      return
    }
    
    dispatch_async(dispatch_get_main_queue()) {
      MenuActionDispatcher.dispatchAction(command)
    }
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

extension RemoteServer: MCNearbyServiceAdvertiserDelegate {
  
  func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession?) -> Void) {
    print("\(#function) \(peerID) - \(context)")
    
    // Accept all invitations
    if connectedSession == nil {
      connectedSession = MCSession(peer: advertiser.myPeerID)
      connectedSession?.delegate = self
    }
    
    invitationHandler(true, connectedSession!)
  }
  
  func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
    print("\(#function) \(error)")
  }
  
}
