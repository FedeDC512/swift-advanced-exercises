//
//  MultipeerViewModel.swift
//  PeerToPeerChat
//
//  Created by Federico Agnello on 20/03/2026.
//

import Foundation
import MultipeerConnectivity
import SwiftUI
import Combine

final class MultipeerViewModel: ObservableObject {
    @Published var connectedPeers: [MCPeerID] = []
    @Published var receivedMessages: [String] = []
    @Published var messageToSend: String = ""
    @Published var displayName: String = ""

    private var service: MultipeerService?

    func startSession(displayName: String) {
        self.displayName = displayName
        service?.disconnect()
        connectedPeers.removeAll()
        receivedMessages.removeAll()

        let newService = MultipeerService(displayName: displayName)
        newService.delegate = self
        service = newService
    }

    func sendMessage() {
        let message = messageToSend.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !message.isEmpty else { return }

        service?.send(message: message)
        receivedMessages.append("Tu: \(message)")
        messageToSend = ""
    }

    func disconnect() {
        service?.disconnect()
    }
}

extension MultipeerViewModel: MultipeerServiceDelegate {
    func didReceiveMessage(_ message: String, from peer: MCPeerID) {
        receivedMessages.append("\(peer.displayName): \(message)")
    }

    func peerDidConnect(_ peerID: MCPeerID) {
        connectedPeers.append(peerID)
    }

    func peerDidDisconnect(_ peerID: MCPeerID) {
        connectedPeers.removeAll { $0 == peerID }
    }
}
