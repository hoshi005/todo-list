//
//  ContentView.swift
//  todo-list
//
//  Created by Susumu Hoshikawa on 2024/02/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Todo List")
        }
    }
}

#Preview {
    ContentView()
}
