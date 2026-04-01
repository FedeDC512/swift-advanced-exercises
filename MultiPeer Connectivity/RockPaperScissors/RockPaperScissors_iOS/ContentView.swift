//
//  ContentView.swift
//  RockPaperScissors_iOS
//
//  Created by Federico Agnello on 31/03/2026.
//

import SwiftUI

struct ContentView: View {
    @State var name = ""
    @State private var roomName: String = ""
    var body: some View {
        NavigationStack{
            TextField("Inserisci nome giocatore", text:$name )
            //.foregroundColor(.white)
                .padding()
            VStack(spacing: 20) {
                Text("Clicca \"Gioca\" per entrare in partita")
                    .font(.title2)
                .pickerStyle(.wheel) // oppure .menu per dropdown
                .padding(.horizontal)
                NavigationLink(destination: NavigationViewExtractedView(name: name, roomName: roomName).navigationBarBackButtonHidden(true)) {
                    Text("Gioca")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(name.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }.disabled(name.isEmpty)            }
            
            
        }
    }
}

struct NavigationViewExtractedView: View {
    @Environment(\.dismiss) var dismiss
    let name: String
    @StateObject private var viewModel = MultipeerViewModel()
    var roomName: String
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    List {
                        Section(header: Text("Giocatori connessi")) {
                            ForEach(viewModel.connectedPeers, id: \.self) {
                                Text($0.displayName)
                            }
                        }
                        Section(header: Text("Cronologia mosse")) {
                            ForEach(viewModel.receivedMessages.indices.reversed(), id: \.self) {
                                Text(viewModel.receivedMessages[$0])
                            }
                        }
                    }

                    if viewModel.isWaitingForOpponentResponse {
                        Text("Attendi l'altro giocatore...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 4)
                    }

                    HStack(spacing: 12) {
                        Button {
                            viewModel.sendMove("rock")
                        } label: {
                            Image("RockWatch")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                                .frame(width: 88, height: 88)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        .disabled(viewModel.connectedPeers.isEmpty || viewModel.isWaitingForOpponentResponse)

                        Button {
                            viewModel.sendMove("paper")
                        } label: {
                            Image("PaperWatch")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                                .frame(width: 88, height: 88)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        .disabled(viewModel.connectedPeers.isEmpty || viewModel.isWaitingForOpponentResponse)

                        Button {
                            viewModel.sendMove("scissors")
                        } label: {
                            Image("ScissorsWatch")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                                .frame(width: 88, height: 88)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        .disabled(viewModel.connectedPeers.isEmpty || viewModel.isWaitingForOpponentResponse)
                    }
                    .padding()
                    
                    Button(action: {
                        viewModel.disconnect()
                        dismiss()
                    }) {
                        Text("Esci dalla partita")
                            .foregroundColor(.red)
                    }
                    .padding(.bottom)
                    .foregroundColor(.red)
                    .padding(.bottom)
                }
            }
            .navigationTitle("Rock Paper Scissors")
        }
        .onAppear {
            viewModel.joinRoom(display_name: name)
        }
    }
}

#Preview {
    ContentView()
}
