//
//  HeaderView.swift
//  MVVM Architecture
//
//  Created by Federico Agnello on 17/03/2026.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var viewModel: TaskListViewModel
    @State private var newTaskTitle = ""

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                TextField("Nuovo task…", text: $newTaskTitle)
                    .textFieldStyle(.roundedBorder)

                Button("Aggiungi") {
                    viewModel.addTask(title: newTaskTitle)
                    newTaskTitle = ""
                }
                .buttonStyle(.borderedProminent)
            }

            Picker("Filtro", selection: $viewModel.filter) {
                ForEach(TaskListViewModel.Filter.allCases) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

#Preview {
    HeaderView(viewModel: TaskListViewModel(service: MockTaskService()))
        .padding()
}
