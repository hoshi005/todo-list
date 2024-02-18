//
//  Todo.swift
//  todo-list
//
//  Created by Susumu Hoshikawa on 2024/02/18.
//

import SwiftUI
import SwiftData

@Model
class Todo {
    private(set) var taskId = UUID().uuidString
    var task: String
    var isCompleted: Bool = false
    var priority: Priority = Priority.normal
    
    init(taskId: String, task: String, isCompleted: Bool, priority: Priority) {
        self.taskId = taskId
        self.task = task
        self.isCompleted = isCompleted
        self.priority = priority
    }
}

/// priority status.
enum Priority: String, Codable, CaseIterable {
    case normal = "Normal"
    case medium = "Medium"
    case high = "High"
    
    var color: Color {
        switch self {
        case .normal:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .red
        }
    }
}
