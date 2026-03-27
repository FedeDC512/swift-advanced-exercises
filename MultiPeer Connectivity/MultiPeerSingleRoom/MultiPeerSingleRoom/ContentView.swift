//
//  ContentView.swift
//  MultiPeerSingleRoom
//
//  Created by Federico Agnello on 20/03/26.
//

import SwiftUI

struct ContentView: View {
    @State var name = ""
    @State private var roomName: String = ""
    var body: some View {
        NavigationStack{
            TextField("Inserisci nome", text:$name )
            //.foregroundColor(.white)
                .padding()
            VStack(spacing: 20) {
                Text("Clicca \"Entra\" per unirti alla stanza")
                    .font(.title2)
                .pickerStyle(.wheel) // oppure .menu per dropdown
                .padding(.horizontal)
                NavigationLink(destination: NavigationViewExtractedView(name: name, roomName: roomName).navigationBarBackButtonHidden(true)) {
                    Text("Entra")
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
                    Text("Stanza: \(viewModel.currentRoom)")
                        .font(.headline)
                    List {
                        Section(header: Text("Peer connessi")) {
                            ForEach(viewModel.connectedPeers, id: \.self) {
                                Text($0.displayName)
                            }
                        }
                        Section(header: Text("Messaggi")) {
                            ForEach(viewModel.receivedMessages.indices, id: \.self) {
                                Text(viewModel.receivedMessages[$0])
                            }
                        }
                    }
                    HStack {
                        TextField("Scrivi un messaggio", text: $viewModel.messageToSend)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button("Invia") {
                            viewModel.sendMessage()
                        }
                    }
                    .padding()
                    
                    Button(action: {
                        viewModel.disconnect()
                        dismiss()
                    }) {
                        Text("Esci dalla stanza")
                            .foregroundColor(.red)
                    }
                    .padding(.bottom)
                    .foregroundColor(.red)
                    .padding(.bottom)
                }
            }
            .navigationTitle("Chat Multipeer")
        }
        .onAppear {
            viewModel.joinRoom(display_name: name)
        }
    }
}

#Preview {
    ContentView()
}
