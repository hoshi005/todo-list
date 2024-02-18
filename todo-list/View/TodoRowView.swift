//
//  TodoRowView.swift
//  todo-list
//
//  Created by Susumu Hoshikawa on 2024/02/18.
//

import SwiftUI

struct TodoRowView: View {
    
    @Bindable var todo: Todo
    @FocusState private var isActive: Bool
    @Environment(\.modelContext) private var context
    
    var body: some View {
        HStack(spacing: 8.0) {
            // キーボードが表示中は非表示にする.
            if !isActive && !todo.task.isEmpty {
                Button(action: {}, label: {
                    Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .padding(3)
                        .contentShape(.rect)
                        .foregroundStyle(todo.isCompleted ? .gray : .primary)
                        .contentTransition(.symbolEffect(.replace))
                })
            }
            
            TextField("Record Video", text: $todo.task)
                .strikethrough(todo.isCompleted)
                .foregroundStyle(todo.isCompleted ? .gray : .primary)
                .focused($isActive)
            
            // キーボードが表示中は非表示にする.
            if !isActive && !todo.task.isEmpty {
                /// priority メニューボタン.
                Menu {
                    ForEach(Priority.allCases, id: \.rawValue) { priority in
                        Button(action: {
                            todo.priority = priority
                        }, label: {
                            HStack {
                                Text(priority.rawValue)
                                
                                if todo.priority == priority {
                                    Image(systemName: "checkmark")
                                }
                            }
                        })
                    }
                } label: {
                    Image(systemName: "circle.fill")
                        .font(.title2)
                        .padding(3)
                        .contentShape(.rect)
                        .foregroundStyle(todo.priority.color.gradient)
            }
            }

        }
        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        .animation(.snappy, value: isActive)
        .onAppear {
            isActive = todo.task.isEmpty
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("", systemImage: "trash") {
                context.delete(todo)
            }
            .tint(.red)
        }
        .onSubmit(of: .text) {
            if todo.task.isEmpty {
                context.delete(todo)
            }
        }
    }
}

#Preview {
    ContentView()
}