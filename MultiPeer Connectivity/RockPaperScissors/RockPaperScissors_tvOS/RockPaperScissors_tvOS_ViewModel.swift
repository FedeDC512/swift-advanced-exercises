//
//  RockPaperScissors_tvOS_ViewModel.swift
//  RockPaperScissors_tvOS
//
//  Created by Federico Agnello on 31/03/2026.
//

import Foundation
import MultipeerConnectivity
import SwiftUI

enum Move: String {
    case rock
    case paper
    case scissors

    var label: String {
        switch self {
        case .rock: return "Rock"
        case .paper: return "Paper"
        case .scissors: return "Scissors"
        }
    }

    func wins(against other: Move) -> Bool {
        (self == .rock && other == .scissors) ||
        (self == .paper && other == .rock) ||
        (self == .scissors && other == .paper)
    }

    var assetName: String {
        switch self {
        case .rock: return "RockTV"
        case .paper: return "PaperTV"
        case .scissors: return "ScissorsTV"
        }
    }
}

struct LastRoundAction: Identifiable {
    let id = UUID()
    let playerName: String
    let move: Move
}

class MultipeerViewModel: ObservableObject, MultipeerServiceDelegate {
    @Published var connectedPeers: [MCPeerID] = []
    @Published var receivedMessages: [String] = []
    @Published var lastRoundActions: [LastRoundAction] = []
    @Published var statusText: String = "In attesa di giocatori..."
    private var service: MultipeerService?
    private var pendingMoves: [String: Move] = [:]
    private var roundOrder: [String] = []
    private var scores: [String: Int] = [:]
    private var roundNumber: Int = 0

    func joinRoom(display_name:String) {
            // Chiudi eventuale sessione precedente
            service?.disconnect()
            receivedMessages = []
            connectedPeers = []
            lastRoundActions = []
            pendingMoves = [:]
            roundOrder = []
            scores = [:]
            roundNumber = 0
            statusText = "Connessione in corso..."
            
            // Crea sessione in modalita arbitro
        let newService = MultipeerService(displayName: display_name)
            newService.delegate = self
            self.service = newService
        }
    
    func disconnect() {
        self.service?.disconnect()
        statusText = "Arbitro disconnesso"
    }
    
    
    
    // MARK: - Delegate Methods
    func didReceiveMessage(_ message: String, _ display_name:String) {
        let normalizedMove = message.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard let move = Move(rawValue: normalizedMove) else {
            receivedMessages.append("Messaggio ignorato da \(display_name): \(message)")
            return
        }

        if pendingMoves[display_name] == nil {
            roundOrder.append(display_name)
        }
        pendingMoves[display_name] = move

        guard pendingMoves.count >= 2 else {
            statusText = "In attesa della seconda mossa..."
            return
        }

        resolveRoundIfReady()
    }
    
    func peerDidConnect(_ peerID: MCPeerID) {
        connectedPeers.append(peerID)
        statusText = "Connesso a \(connectedPeers.count) giocatore/i"
    }
    
    func peerDidDisconnect(_ peerID: MCPeerID) {
        connectedPeers.removeAll { $0 == peerID }
        pendingMoves.removeValue(forKey: peerID.displayName)
        roundOrder.removeAll { $0 == peerID.displayName }
        statusText = connectedPeers.isEmpty ? "In attesa di giocatori..." : "Connesso a \(connectedPeers.count) giocatore/i"
    }

    private func resolveRoundIfReady() {
        let activePlayers = roundOrder.filter { pendingMoves[$0] != nil }
        guard activePlayers.count >= 2 else { return }

        let playerA = activePlayers[0]
        let playerB = activePlayers[1]
        guard let moveA = pendingMoves[playerA], let moveB = pendingMoves[playerB] else { return }

        roundNumber += 1

        let outcomeMessage: String
        if moveA == moveB {
            outcomeMessage = "ROUND \(roundNumber): Pareggio - \(playerA) e \(playerB) hanno scelto \(moveA.label)."
            statusText = "Round \(roundNumber) pareggiato"
        } else if moveA.wins(against: moveB) {
            scores[playerA, default: 0] += 1
            outcomeMessage = "ROUND \(roundNumber): Vince \(playerA) con \(moveA.label) contro \(moveB.label) di \(playerB)."
            statusText = "Round \(roundNumber) vinto da \(playerA)"
        } else {
            scores[playerB, default: 0] += 1
            outcomeMessage = "ROUND \(roundNumber): Vince \(playerB) con \(moveB.label) contro \(moveA.label) di \(playerA)."
            statusText = "Round \(roundNumber) vinto da \(playerB)"
        }

        let scoreA = scores[playerA, default: 0]
        let scoreB = scores[playerB, default: 0]
        let scoreboard = "SCORE: \(playerA) \(scoreA) - \(scoreB) \(playerB)"

        lastRoundActions = [
            LastRoundAction(playerName: playerA, move: moveA),
            LastRoundAction(playerName: playerB, move: moveB)
        ]

        receivedMessages.append(outcomeMessage)
        receivedMessages.append(scoreboard)
        service?.send(message: outcomeMessage)
        service?.send(message: scoreboard)

        pendingMoves = [:]
        roundOrder = []
    }
}
