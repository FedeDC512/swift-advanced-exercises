//
//  ContentView.swift
//  RockPaperScissors_tvOS
//
//  Created by Federico Agnello on 31/03/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Rock Paper Scissors")
                    .font(.largeTitle)
                    .bold()

                Text("Apple TV arbitro: riceve le mosse dei due player, calcola l'esito e invia il vincitore.")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                NavigationLink(destination: SpectatorView().navigationBarBackButtonHidden(true)) {
                    Text("Avvia arbitro")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
        }
    }
}

struct SpectatorView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = MultipeerViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 14) {
                Text(viewModel.statusText)
                    .font(.headline)
                    .padding(.top)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Giocatori connessi")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    ForEach(Array(viewModel.connectedPeers.prefix(2)), id: \.self) { peer in
                        Text(peer.displayName)
                            .font(.footnote)
                    }

                    if viewModel.connectedPeers.isEmpty {
                        Text("In attesa di connessioni")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                VStack(spacing: 16) {
                    Text("Ultime mosse")
                        .font(.title2)
                        .bold()

                    if viewModel.lastRoundActions.isEmpty {
                        Text("Nessuna partita completata")
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 180)
                    } else {
                        HStack(spacing: 32) {
                            ForEach(Array(viewModel.lastRoundActions.prefix(2))) { action in
                                VStack(spacing: 10) {
                                    Image(action.move.assetName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120, height: 120)

                                    Text(action.playerName)
                                        .font(.title3)
                                        .lineLimit(1)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 260)
                .padding()
                .background(Color.white.opacity(0.08))
                .cornerRadius(12)
                .padding(.horizontal)

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.receivedMessages.indices.reversed(), id: \.self) {
                            Text(viewModel.receivedMessages[$0])
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.horizontal)
                }

                Button(action: {
                    viewModel.disconnect()
                    dismiss()
                }) {
                    Text("Esci")
                        .foregroundColor(.red)
                }
                .padding(.vertical)
            }
            .navigationTitle("Arbitro TV")
        }
        .onAppear {
            viewModel.joinRoom(display_name: "AppleTV-Arbitro")
        }
    }
}

#Preview {
    ContentView()
}
