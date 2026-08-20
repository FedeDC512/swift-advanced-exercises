//
//  ContentView.swift
//  PeerToPeerChat
//
//  Created by Federico Agnello on 20/03/2026.
//

import SwiftUI
import MultipeerConnectivity

struct ContentView: View {
    @StateObject private var viewModel = MultipeerViewModel()
    @State private var name: String = ""
    @State private var didStart = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("Inserisci il tuo nome", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                Button("Avvia chat") {
                    viewModel.startSession(displayName: name)
                    didStart = true
                }
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                if didStart {
                    List {
                        Section("Peer connessi") {
                            ForEach(viewModel.connectedPeers, id: \.self) { peer in
                                Text(peer.displayName)
                            }
                        }

                        Section("Messaggi") {
                            ForEach(viewModel.receivedMessages.indices, id: \.self) { index in
                                Text(viewModel.receivedMessages[index])
                            }
                        }
                    }

                    HStack {
                        TextField("Scrivi un messaggio", text: $viewModel.messageToSend)
                            .textFieldStyle(.roundedBorder)

                        Button("Invia") {
                            viewModel.sendMessage()
                        }
                    }
                    .padding(.horizontal)

                    Button("Disconnetti") {
                        viewModel.disconnect()
                        didStart = false
                    }
                    .foregroundColor(.red)
                    .padding(.bottom)
                }
            }
            .navigationTitle("Peer-to-Peer Chat")
        }
    }
}

#Preview {
    ContentView()
}
