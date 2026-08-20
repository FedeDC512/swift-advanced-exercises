//
//  MultipeerService.swift
//  PeerToPeerChat
//
//  Created by Federico Agnello on 20/03/2026.
//

import Foundation
import MultipeerConnectivity
import UIKit

protocol MultipeerServiceDelegate: AnyObject {
    func didReceiveMessage(_ message: String, from peer: MCPeerID)
    func peerDidConnect(_ peerID: MCPeerID)
    func peerDidDisconnect(_ peerID: MCPeerID)
}

final class MultipeerService: NSObject {
    private let serviceType = "p2p-chat"
    private let myPeerID: MCPeerID
    private let session: MCSession
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?

    weak var delegate: MultipeerServiceDelegate?

    init(displayName: String = UIDevice.current.name) {
        myPeerID = MCPeerID(displayName: displayName)
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)

        super.init()
        session.delegate = self
        startBrowsing()
        startAdvertising()
    }

    func startAdvertising() {
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID,
                                               discoveryInfo: nil,
                                               serviceType: serviceType)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }

    func startBrowsing() {
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }

    func send(message: String) {
        guard !session.connectedPeers.isEmpty else { return }
        guard let data = message.data(using: .utf8) else { return }

        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("Send error: \(error)")
        }
    }

    func disconnect() {
        advertiser?.stopAdvertisingPeer()
        browser?.stopBrowsingForPeers()
        session.disconnect()
    }
}

extension MultipeerService: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .connected:
                self.delegate?.peerDidConnect(peerID)
            case .notConnected:
                self.delegate?.peerDidDisconnect(peerID)
            case .connecting:
                break
            @unknown default:
                break
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = String(data: data, encoding: .utf8) else { return }
        DispatchQueue.main.async {
            self.delegate?.didReceiveMessage(message, from: peerID)
        }
    }

    func session(_ session: MCSession,
                 didReceive stream: InputStream,
                 withName streamName: String,
                 fromPeer peerID: MCPeerID) {}

    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 with progress: Progress) {}

    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL?,
                 withError error: Error?) {}
}

extension MultipeerService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didNotStartAdvertisingPeer error: Error) {
        print("Advertising error: \(error)")
    }
}

extension MultipeerService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {}

    func browser(_ browser: MCNearbyServiceBrowser,
                 didNotStartBrowsingForPeers error: Error) {
        print("Browsing error: \(error)")
    }
}
