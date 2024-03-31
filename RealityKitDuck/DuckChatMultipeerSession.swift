//
//  DuckChatMultipeerSession.swift
//  RealityKitDuck
//
//  Created by John Brewer on 3/30/24.
//

import Foundation
import MultipeerConnectivity

@Observable
class DuckChatMultipeerSession: NSObject {
    private let serviceType = "duckchat-svc"
    let myPeerID: MCPeerID
    let session: MCSession
    let advertiser: MCNearbyServiceAdvertiser
    let browser: MCNearbyServiceBrowser
    
    public var availablePeers: [MCPeerID] = []
    public var receivedMessage: String = ""
    public var receivedInvite: Bool = false
    public var paired: Bool = false
    public var invitationHandler: ((Bool, MCSession?) -> Void)?
    
    public var messageLog: String = ""
    
    init(displayName: String) {
        myPeerID = MCPeerID(displayName: displayName)
        session = MCSession(peer: myPeerID,
                            securityIdentity: nil,
                            encryptionPreference: .required)
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID,
                                               discoveryInfo: nil,
                                               serviceType: serviceType)
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        super.init()
        
        session.delegate = self
        advertiser.delegate = self
        browser.delegate = self
        
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    
    deinit {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
    }
    
    func sendMessage(message: String) {
        print("\(availablePeers)")
        do {
            try session.send(message.data(using: .utf8)!, toPeers: availablePeers, with: .reliable)
        } catch {
            print("\(error)")
        }
    }
}

extension DuckChatMultipeerSession: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("\(peerID) = \(data)")
        messageLog.append(String(data: data, encoding: .utf8)!)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("\(peerID) = \(state)")
    }
    
    func session(_ session: MCSession,
                 didReceiveCertificate certificate: [Any]?,
                 fromPeer peerID: MCPeerID,
                 certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }

    // MARK: -- Not supported

    func session(_ session: MCSession,
                 didReceive stream: InputStream,
                 withName streamName: String,
                 fromPeer peerID: MCPeerID) {
        fatalError("Streaming not supported")
    }
    
    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 with progress: Progress) {
        fatalError("Resources not supported")
    }
    
    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL?,
                 withError error: (any Error)?) {
        fatalError("Resources not supported")
    }
}

extension DuckChatMultipeerSession: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("didReceiveInvitationFromPeer: \(peerID)")
        availablePeers.append(peerID)
        invitationHandler(true, session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didNotStartAdvertisingPeer error: any Error) {
        print("didNotStartAdvertisingPeer, error = \(error)")
    }
}

extension DuckChatMultipeerSession: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {
        print("Found peer: \(peerID)")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 0)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost peer: \(peerID)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: any Error) {
        print("didNotStartBrowsingForPeers error = \(error)")
    }
}
