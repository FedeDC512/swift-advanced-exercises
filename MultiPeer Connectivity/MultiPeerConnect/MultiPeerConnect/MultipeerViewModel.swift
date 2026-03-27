//
//  MultipeerViewModel.swift
//  MultiPeerConnect
//
//  Created by Federico Agnello on 27/03/26.
//

import Foundation
import MultipeerConnectivity
import SwiftUI
import Combine

class MultipeerViewModel: ObservableObject, MultipeerServiceDelegate {
    @Published var connectedPeers: [MCPeerID] = []
    @Published var receivedMessages: [String] = []
    @Published var messageToSend: String = ""
    @Published var currentRoom: String = ""
        private var service: MultipeerService?

    func joinRoom(display_name:String, named room: String) {
            // Chiudi eventuale sessione precedente
            service?.disconnect()
            receivedMessages = []
            connectedPeers = []
            
            // Crea nuova stanza
        let newService = MultipeerService(displayName: display_name, roomName: room)
            newService.delegate = self
            self.service = newService
            self.currentRoom = room
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
