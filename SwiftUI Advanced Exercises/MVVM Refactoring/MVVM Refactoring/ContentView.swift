//
//  ContentView.swift
//  MVVM Refactoring
//
//  Created by Federico Agnello on 17/03/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PhotoLibraryViewModel()
    @State var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection)  {
            ListView(viewModel: viewModel)
                .tabItem {
                    Label("Photos", systemImage: "photo")
                        .accentColor(.primary)
                }
                .tag(0)
     
            ModifiedView(viewModel: viewModel)
                .tabItem {
                    Label("Modified", systemImage: "camera.filters")
                        .accentColor(.primary)
                }
                .tag(1)
        }
    }
}

#Preview {
    ContentView()
}

