//
//  TodoRowView.swift
//  todo-list
//
//  Created by Susumu Hoshikawa on 2024/02/18.
//

import SwiftUI

struct TodoRowView: View {
    
    @Bindable var todo: Todo
    
    var body: some View {
        HStack(spacing: 8.0) {
            Button(action: {}, label: {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .padding(3)
                    .contentShape(.rect)
                    .foregroundStyle(todo.isCompleted ? .gray : .primary)
                    .contentTransition(.symbolEffect(.replace))
            })
            
            TextField("Record Video", text: $todo.task)
                .strikethrough(todo.isCompleted)
                .foregroundStyle(todo.isCompleted ? .gray : .primary)
            
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
}

#Preview {
    ContentView()
}
