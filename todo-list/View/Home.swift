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
    
    var body: some View {
        List {
            Section(activeSectionTitle) {
                
            }
            
            /// Completed List
            CompletedTodoList()
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "plus.circle.fill")
                        .fontWeight(.light)
                        .font(.system(size: 42))
                })
            }
        }
    }
    
    var activeSectionTitle: String {
        let count = activeList.count
        return count == 0 ? "Active" : "Active (\(count)"
    }
}

#Preview {
    ContentView()
}
