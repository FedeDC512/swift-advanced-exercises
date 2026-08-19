//
//  ContentView.swift
//  MVVM Architecture
//
//  Created by Federico Agnello on 17/03/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TaskListViewModel(service: MockTaskService())

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Caricamento…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let message = viewModel.errorMessage {
                    ErrorStateView(message: message) {
                        Task { await viewModel.load() }
                    }
                } else if viewModel.filteredTasks.isEmpty {
                    EmptyStateView()
                } else {
                    TaskListView(viewModel: viewModel)
                }
            }
            .navigationTitle("TaskBoard")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .top) {
                HeaderView(viewModel: viewModel)
                    .padding([.horizontal, .top])
                    .background(.bar)
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    ContentView()
}
