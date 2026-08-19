//
//  NavigationView.swift
//  SwiftUI Navigation
//
//  Created by Federico Agnello on 17/03/2026.
//

import SwiftUI

struct NavigationView: View {

    let items = ["Apple", "Banana", "Orange", "Strawberry"]

    var body: some View {
        NavigationStack {
            List(items, id: \.self) { item in
                NavigationLink(value: item) {
                    Text(item)
                }
            }
            .navigationTitle("Fruits")
            .navigationDestination(for: String.self) { item in
                DetailView(item: item)
            }
        }
    }
}

struct DetailView: View {

    let item: String

    var body: some View {
        VStack(spacing: 20) {
            Text("Detail View")
                .font(.title)

            Text(item)
                .font(.largeTitle)
        }
    }
}

#Preview {
    NavigationView()
}
