//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Kesavan Yogeswaran on 7/29/24.
//

import SwiftUI
import SwiftData

@main
struct iExpenseApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: ExpenseItem.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
