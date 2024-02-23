//
//  todo_widget.swift
//  todo-widget
//
//  Created by Susumu Hoshikawa on 2024/02/23.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: .now)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct todo_widgetEntryView : View {
    var entry: Provider.Entry
    
    @Query(todoDescriptor, animation: .snappy) private var activeList: [Todo]
    var body: some View {
        VStack {
            ForEach(activeList) { todo in
                HStack(spacing: 8.0) {
                    Button(intent: ToggleButton(id: todo.taskId)) {
                        Image(systemName: "circle")
                    }
                    .font(.callout)
                    .tint(todo.priority.color.gradient)
                    .buttonBorderShape(.circle)
                    
                    Text(todo.task)
                        .font(.callout)
                        .lineLimit(1)
                    
                    Spacer()
                }
                .transition(.push(from: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if activeList.isEmpty {
                Text("No Tasks 🎉")
                    .font(.callout)
                    .transition(.push(from: .bottom))
            }
        }
    }
    
    static var todoDescriptor: FetchDescriptor<Todo> {
        let predicate = #Predicate<Todo> { !$0.isCompleted }
        let sort = [SortDescriptor(\Todo.updatedAt, order: .reverse)]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        descriptor.fetchLimit = 3
        return descriptor
    }
}

struct todo_widget: Widget {
    let kind: String = "Todo List"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            todo_widgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                // setting up SwiftData Container
                .modelContainer(for: Todo.self)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Tasks")
        .description("This is a Todo List")
    }
}

#Preview(as: .systemSmall) {
    todo_widget()
} timeline: {
    SimpleEntry(date: .now)
}

struct ToggleButton: AppIntent {
    static var title: LocalizedStringResource = .init(stringLiteral: "Toggle's Todo State")
    
    @Parameter(title: "Todo ID")
    var id: String
    
    init(){}
    
    init(id: String) {
        self.id = id
    }
    
    func perform() async throws -> some IntentResult {
        
        let context = try ModelContext(.init(for: Todo.self))
        let descriptor = FetchDescriptor(predicate: #Predicate<Todo> { $0.taskId == id })
        if let todo = try context.fetch(descriptor).first {
            todo.isCompleted = true
            todo.updatedAt = .now
            
            try context.save()
        }
        return .result()
    }
}
