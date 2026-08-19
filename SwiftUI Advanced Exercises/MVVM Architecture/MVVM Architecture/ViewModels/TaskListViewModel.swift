//
//  TaskListViewModel.swift
//  MVVM Architecture
//
//  Created by Federico Agnello on 17/03/2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class TaskListViewModel: ObservableObject {
    
    enum Filter: String, CaseIterable, Identifiable {
        case all = "Tutte"
        case open = "Aperte"
        case done = "Completate"

        var id: String { rawValue }
    }

    @Published private(set) var tasks: [TodoTask] = []
    @Published var filter: Filter = .all
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let service: TaskService

    init(service: TaskService) {
        self.service = service
    }

    var filteredTasks: [TodoTask] {
        switch filter {
        case .all:
            return tasks
        case .open:
            return tasks.filter { !$0.isDone }
        case .done:
            return tasks.filter { $0.isDone }
        }
    }
    
    func test() {
        print("test")
    }

    func load() async -> Void {
        isLoading = true
        errorMessage = nil

        do {
            tasks = try await service.fetchTasks()
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }

        isLoading = false
    }

    func addTask(title: String) {
        let cleaned = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else { return }
        tasks.insert(TodoTask(title: cleaned), at: 0)
    }

    func toggleDone(for task: TodoTask) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks[index].isDone.toggle()
    }

    func delete(at offsets: IndexSet) {
        let idsToDelete = offsets.map { filteredTasks[$0].id }
        tasks.removeAll { idsToDelete.contains($0.id) }
    }
}
