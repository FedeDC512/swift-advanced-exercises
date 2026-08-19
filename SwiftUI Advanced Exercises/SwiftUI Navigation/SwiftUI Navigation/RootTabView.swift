//
//  RootTabView.swift
//  SwiftUI Navigation
//
//  Created by Federico Agnello on 17/03/2026.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationView()
                .tabItem {
                    Label("Stack", systemImage: "list.bullet")
                }

            ModalView()
                .tabItem {
                    Label("Modals", systemImage: "square.and.arrow.up")
                }

            SplitView()
                .tabItem {
                    Label("Split", systemImage: "sidebar.left")
                }
        }
    }
}

#Preview {
    RootTabView()
}
