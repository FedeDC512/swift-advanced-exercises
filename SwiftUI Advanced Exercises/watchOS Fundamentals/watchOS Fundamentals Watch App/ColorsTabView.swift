//
//  ColorsTabView.swift
//  watchOS Fundamentals
//
//  Created by Federico Agnello on 25/03/2026.
//

import SwiftUI

struct ColorsTabView: View {
    var list: [String] = ["Palermo", "Catania", "Messina", "Agrigento", "Caltanissetta", "Enna"]

    var body: some View {
        TabView {
            
            Text("Tab 1")
                .containerBackground(.red.gradient, for: .tabView)
            Text("Tab 2")
                .containerBackground(.green.gradient, for: .tabView)
            Text("Tab 3")
                .containerBackground(.blue.gradient, for: .tabView)
            
            List{
                ForEach(list, id: \.self) { item in Text(item) }
            }
        }.tabViewStyle(.verticalPage)
    }
}

#Preview {
    ColorsTabView()
}
