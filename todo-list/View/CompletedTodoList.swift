//
//  CompletedTodoList.swift
//  todo-list
//
//  Created by Susumu Hoshikawa on 2024/02/18.
//

import SwiftUI
import SwiftData

struct CompletedTodoList: View {
    
    @Query private var completedList: [Todo]
    @State private var showAll = false
    
    init() {
        let predicate = #Predicate<Todo> { $0.isCompleted }
        let sort = [SortDescriptor(\Todo.updatedAt, order: .reverse)]
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        if !showAll {
            descriptor.fetchLimit = 15
        }
        
        _completedList = Query(descriptor, animation: .snappy)
    }
    
    var body: some View {
        Section {
            
        } header: {
            HStack {
                Text("Completed")
                
                Spacer()
                
                if showAll {
                    Button("Show Recents") {
                        showAll = false
                    }
                }
            }
            .font(.caption)
        } footer: {
            if completedList.count > 15 && !showAll {
                HStack {
                    Text("Showing Recent 15 Tasks")
                        .foregroundStyle(.gray)
                    Button("Show All") {
                        showAll = true
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
