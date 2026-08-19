//
//  TaskService.swift
//  MVVM Architecture
//
//  Created by Federico Agnello on 17/03/2026.
//

import Foundation

protocol TaskService {
    func fetchTasks() async throws -> [TodoTask]
}

enum DemoError: Error, LocalizedError {
    case randomFailure

    var errorDescription: String? {
        switch self {
        case .randomFailure:
            return "Errore simulato di rete. Riprova."
        }
    }
}

struct MockTaskService: TaskService {
    var shouldFail: Bool = false

    func fetchTasks() async throws -> [TodoTask] {
        try await Task.sleep(nanoseconds: 700_000_000)

        if shouldFail {
            throw DemoError.randomFailure
        }

        return [
            TodoTask(title: "Guardare le slide MVVM", isDone: true),
            TodoTask(title: "Studiare @StateObject e @ObservedObject"),
            TodoTask(title: "Svolgere gli esercizi")
        ]
    }
}
