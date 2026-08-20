//
//  CitiesSplitView.swift
//  watchOS Fundamentals
//
//  Created by Federico Agnello on 25/03/2026.
//

import SwiftUI

struct CitiesSplitView: View {
    
    var list: [String] = ["palermo", "roma", "napoli", "genova", "firenze", "bari"]
    
    @State var selection: String?
    
    var body: some View {
        NavigationSplitView {
            VStack{
                List(list, id:\.self, selection: $selection){
                    item in Text(item.capitalized)
                }
            }
        } detail: { DetailView(selection: $selection) }
    }
}

struct DetailView: View {
    
    @Binding var selection: String?
    
    var body: some View {
        Group {
            if let selection {
                ScrollView {
                    VStack(spacing: 12) {
                        Image(selection)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle (cornerRadius: 12, style: .continuous))
                            .shadow(radius: 2)
                        Text(selection.capitalized)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }.padding()
                }
            } else {
                ContentUnavailableView("Nessuna Selezione", systemImage: "hand.tap", description: Text("Seleziona un elemento dalla lista"))
            }
        }
    }
}

#Preview {
    CitiesSplitView()
}
