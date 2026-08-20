//
//  ContentView.swift
//  watchOS Fundamentals Watch App
//
//  Created by Federico Agnello on 25/03/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Crown Rotation") {
                    CrownView()
                }
                NavigationLink("Split View") {
                    CitiesSplitView()
                }
                NavigationLink("Tab View") {
                    ColorsTabView()
                }
            }
            .navigationTitle("watchOS")
        }
    }
}

#Preview {
    ContentView()
}
