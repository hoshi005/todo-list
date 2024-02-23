//
//  todo_widgetBundle.swift
//  todo-widget
//
//  Created by Susumu Hoshikawa on 2024/02/23.
//

import WidgetKit
import SwiftUI

@main
struct todo_widgetBundle: WidgetBundle {
    var body: some Widget {
        todo_widget()
        todo_widgetLiveActivity()
    }
}
