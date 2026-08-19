//
//  SplitView.swift
//  SwiftUI Navigation
//
//  Created by Federico Agnello on 17/03/2026.
//

import SwiftUI

struct SplitView: View {

    let items = ["One","Two","Three"]
    @State private var selection: String?

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all), sidebar: {
            List(items, id: \.self, selection: $selection) { item in
                Text(item)
                   .tag(item)
            }
            .navigationTitle("Sidebar")
        }, detail: {
            Group {
                if let selection {
                    switch selection {
                    case "One":
                        DetailOneView()
                    case "Two":
                        DetailTwoView()
                    case "Three":
                        DetailThreeView()
                    default:
                        Text("Unknown selection: \(selection)")
                    }
                } else {
                    Text("Select an item")
                }
            }
            .navigationTitle(selection ?? "Detail")
        })
    }
}

private struct DetailOneView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Detail for One").font(.title)
            Text("This is the page for item One.")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct DetailTwoView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Detail for Two").font(.title)
            Text("This is the page for item Two.")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct DetailThreeView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Detail for Three").font(.title)
            Text("This is the page for item Three.")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SplitView()
}
