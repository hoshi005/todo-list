//
//  CompletedTodoList.swift
//  todo-list
//
//  Created by Susumu Hoshikawa on 2024/02/18.
//

import SwiftUI
import SwiftData

struct CompletedTodoList: View {
    
    let limit = 5
    
    @Query private var completedList: [Todo]
    @Binding var showAll: Bool
    
    init(showAll: Binding<Bool>) {
        let predicate = #Predicate<Todo> { $0.isCompleted }
        let sort = [SortDescriptor(\Todo.updatedAt, order: .reverse)]
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        if !showAll.wrappedValue {
            descriptor.fetchLimit = limit
        }
        
        _completedList = Query(descriptor, animation: .snappy)
        _showAll = showAll
    }
    
    var body: some View {
        Section {
            ForEach(completedList) {
                TodoRowView(todo: $0)
            }
        } header: {
            HStack {
                Text("Completed")
                
                Spacer()
                
                if showAll {
                    Button("Show Recents") {
                        withAnimation(.snappy) {
                            showAll = false
                        }
                    }
                }
            }
            .font(.caption)
        } footer: {
            if completedList.count == limit && !showAll {
                HStack {
                    Text("Showing Recent \(limit) Tasks")
                        .foregroundStyle(.gray)
                    Button("Show All") {
                        withAnimation(.snappy) {
                            showAll = true
                        }
                    }
                }
                .font(.caption)
            }
        }

    }
}

#Preview {
    ContentView()
}
