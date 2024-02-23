//
//  todo_widget.swift
//  todo-widget
//
//  Created by Susumu Hoshikawa on 2024/02/23.
//

import WidgetKit
import SwiftUI
import SwiftData

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
                    Button(action: {}, label: {
                        Image(systemName: "circle")
                    })
                    .font(.callout)
                    .tint(todo.priority.color.gradient)
                    .buttonBorderShape(.circle)
                    
                    Text(todo.task)
                        .font(.callout)
                        .lineLimit(1)
                    
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
        .configurationDisplayName("Tasks")
        .description("This is a Todo List")
    }
}

#Preview(as: .systemSmall) {
    todo_widget()
} timeline: {
    SimpleEntry(date: .now)
}
