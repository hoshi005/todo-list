//
//  Home.swift
//  todo-list
//
//  Created by Susumu Hoshikawa on 2024/02/18.
//

import SwiftUI
import SwiftData

struct Home: View {
    
    /// Active Todo's
    @Query(filter: #Predicate<Todo> { !$0.isCompleted }, sort: [SortDescriptor(\Todo.updatedAt, order: .reverse)], animation: .snappy) var activeList: [Todo]
    
    /// Model Context
    @Environment(\.modelContext) private var context
    
    var body: some View {
        List {
            Section(activeSectionTitle) {
                ForEach(activeList) {
                    TodoRowView(todo: $0)
                }
            }
            
            /// Completed List
            CompletedTodoList()
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    // 空タスクの作成と保存.
                    let todo = Todo(task: "", priority: .normal)
                    context.insert(todo)
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .fontWeight(.light)
                        .font(.system(size: 42))
                })
            }
        }
    }
    
    var activeSectionTitle: String {
        let count = activeList.count
        return count == 0 ? "Active" : "Active (\(count))"
    }
}

#Preview {
    ContentView()
}
