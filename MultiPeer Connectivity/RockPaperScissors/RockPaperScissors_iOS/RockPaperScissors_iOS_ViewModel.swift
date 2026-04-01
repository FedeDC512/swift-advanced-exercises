//
//  RockPaperScissors_iOS_ViewModel.swift
//  RockPaperScissors_iOS
//
//  Created by Federico Agnello on 31/03/2026.
//

import Foundation
import MultipeerConnectivity
import SwiftUI

class MultipeerViewModel: ObservableObject, MultipeerServiceDelegate {
    @Published var connectedPeers: [MCPeerID] = []
    @Published var receivedMessages: [String] = []
    @Published var currentRoom: String = "Partita RPS"
    @Published var isWaitingForOpponentResponse: Bool = false
    private var service: MultipeerService?

    func joinRoom(display_name:String) {
            // Chiudi eventuale sessione precedente
            service?.disconnect()
            receivedMessages = []
            connectedPeers = []
            isWaitingForOpponentResponse = false
            
            // Crea nuova stanza
        let newService = MultipeerService(displayName: display_name)
            newService.delegate = self
            self.service = newService
            self.currentRoom = "Partita RPS"
        }
    
    func sendMove(_ move: String) {
        guard !connectedPeers.isEmpty else { return }
        guard !isWaitingForOpponentResponse else { return }
        service?.send(message: move)
        isWaitingForOpponentResponse = true
    }
    
    func disconnect() {
        self.service?.disconnect()
        isWaitingForOpponentResponse = false
    }
    
    
    
    // MARK: - Delegate Methods
    func didReceiveMessage(_ message: String, _ display_name:String) {
        guard isTVSender(display_name) else { return }
        receivedMessages.append(message)
        isWaitingForOpponentResponse = false
    }
    
    func peerDidConnect(_ peerID: MCPeerID) {
        connectedPeers.append(peerID)
    }
    
    func peerDidDisconnect(_ peerID: MCPeerID) {
        connectedPeers.removeAll { $0 == peerID }
    }

    private func isTVSender(_ displayName: String) -> Bool {
        let normalizedName = displayName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return normalizedName.contains("tv") || normalizedName.contains("arbitro")
    }
}
