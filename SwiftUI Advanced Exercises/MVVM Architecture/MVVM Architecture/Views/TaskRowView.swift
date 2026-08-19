//
//  TaskRowView.swift
//  MVVM Architecture
//
//  Created by Federico Agnello on 17/03/2026.
//

import SwiftUI

struct TaskRowView: View {
    let task: TodoTask
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                .imageScale(.large)

            Text(task.title)
                .strikethrough(task.isDone)

            Spacer()

            Button(task.isDone ? "Riapri" : "Fatto") {
                onToggle()
            }
            .buttonStyle(.bordered)
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onToggle)
    }
}

#Preview {
    TaskRowView(task: TodoTask(title: "Task di esempio"), onToggle: {})
        .padding()
}
