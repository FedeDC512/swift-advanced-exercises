//
//  MultipeerViewModel.swift
//  MultiPeerSingleRoom
//
//  Created by Federico Agnello on 20/03/26.
//

import Foundation
import MultipeerConnectivity
import SwiftUI

class MultipeerViewModel: ObservableObject, MultipeerServiceDelegate {
    @Published var connectedPeers: [MCPeerID] = []
    @Published var receivedMessages: [String] = []
    @Published var messageToSend: String = ""
    @Published var currentRoom: String = "Stanza unica"
        private var service: MultipeerService?

    func joinRoom(display_name:String) {
            // Chiudi eventuale sessione precedente
            service?.disconnect()
            receivedMessages = []
            connectedPeers = []
            
            // Crea nuova stanza
        let newService = MultipeerService(displayName: display_name)
            newService.delegate = self
            self.service = newService
            self.currentRoom = "Stanza unica"
        }
    
    func sendMessage() {
        let message = messageToSend.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !message.isEmpty else { return }
        service?.send(message: message)
        receivedMessages.append("Tu: \(message)")
        messageToSend = ""
    }
    
    func disconnect() {
        self.service?.disconnect()
    }
    
    
    
    // MARK: - Delegate Methods
    func didReceiveMessage(_ message: String, _ display_name:String) {
        receivedMessages.append("\(display_name): \(message)")
    }
    
    func peerDidConnect(_ peerID: MCPeerID) {
        connectedPeers.append(peerID)
    }
    
    func peerDidDisconnect(_ peerID: MCPeerID) {
        connectedPeers.removeAll { $0 == peerID }
    }
}
