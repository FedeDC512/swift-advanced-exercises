//
//  TaskListView.swift
//  MVVM Architecture
//
//  Created by Federico Agnello on 17/03/2026.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel: TaskListViewModel

    var body: some View {
        List {
            ForEach(viewModel.filteredTasks) { task in
                TaskRowView(task: task) {
                    viewModel.toggleDone(for: task)
                }
            }
            .onDelete(perform: viewModel.delete)
        }
        .listStyle(.plain)
    }
}

#Preview {
    TaskListView(viewModel: TaskListViewModel(service: MockTaskService()))
}
