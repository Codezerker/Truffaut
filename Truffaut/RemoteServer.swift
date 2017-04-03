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
  fileprivate var connectedSession: MCSession?
  
  func start() {
    guard self.advertiser == nil else {
      return
    }
    
    let displayName = "Truffaut on \"\(Host.current().localizedName ?? "Unknown Device")\""
    let peerID = MCPeerID(displayName: displayName)
    let advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: RemoteProtocol.serviceType)
    advertiser.delegate = self
    advertiser.startAdvertisingPeer()
    
    self.advertiser = advertiser
  }
  
}

extension RemoteServer: MCSessionDelegate {
  
  @available(OSX 10.10, *)
  public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
    // ...
  }

  @available(OSX 10.10, *)
  public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    // ...
  }

  @available(OSX 10.10, *)
  public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    // ...
  }

  
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    print("\(#function) \(peerID) - \(state.rawValue)")
    
    switch state {
    case MCSessionState.notConnected:
      connectedSession = nil
    default:
      break
    }
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    print("\(#function) \(data.count) - \(peerID)")
    
    guard let command = RemoteProtocol.Command(data: data) else {
      return
    }
    
    DispatchQueue.main.async {
      MenuActionDispatcher.dispatchAction(command: command)
    }
  }
}

extension RemoteServer: MCNearbyServiceAdvertiserDelegate {
  
  func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    print("\(#function) \(peerID) - \(String(describing: context))")
    
    // Accept all invitations
    if connectedSession == nil {
      connectedSession = MCSession(peer: advertiser.myPeerID)
      connectedSession?.delegate = self
    }
    
    invitationHandler(true, connectedSession!)
  }
}
