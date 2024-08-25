//
//  ContentView.swift
//  iExpense
//
//  Created by Kesavan Yogeswaran on 7/29/24.
//

import SwiftUI
import SwiftData

enum ExpenseType: String, Hashable, Codable, CaseIterable {
    case personal, business
}

@Model
class ExpenseItem: Equatable {
    var name: String
    // Apparently need to store this as a string to be compatible with SwiftData Predicates
    var type: String
    var amount: Double
    
    init(name: String, type: ExpenseType, amount: Double) {
        self.name = name
        self.type = type.rawValue
        self.amount = amount
    }
    
    enum SortOrder: String, CaseIterable {
        case name, amount
        
        var descriptor: [SortDescriptor<ExpenseItem>] {
            switch self {
            case .name:
                [
                    SortDescriptor(\ExpenseItem.name),
                    SortDescriptor(\ExpenseItem.amount, order: .reverse),
                ]
            case .amount:
                [
                    SortDescriptor(\ExpenseItem.amount, order: .reverse),
                    SortDescriptor(\ExpenseItem.name),
                ]
            }
        }
    }
}

func styleAmount(_ amount: Double) -> some ShapeStyle {
    if amount < 10 {
        return .black
    } else if amount < 100 {
        return .yellow
    } else {
        return .red
    }
}

struct ContentView: View {
    @Query private var expenses: [ExpenseItem]
    @State private var showingAddExpense = false
    @Environment(\.modelContext) var modelContext
    @State private var shownExpenseTypes = ExpenseType.allCases
    @State private var sortOrder = ExpenseItem.SortOrder.name
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(shownExpenseTypes, id: \.self) { expenseType in
                    ExpenseList(expenseType: expenseType, sortOrder: sortOrder.descriptor)
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink(value: 0) {
                    Image(systemName: "plus")
                }
                Picker("Filter expense type", selection: $shownExpenseTypes) {
                    ForEach(ExpenseType.allCases, id: \.self) { expenseType in
                        Text(expenseType.rawValue.capitalized)
                            .tag([expenseType])
                    }
                    Text("All")
                        .tag(ExpenseType.allCases)
                }
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        ForEach(ExpenseItem.SortOrder.allCases, id: \.self) {
                            Text("Sort by \($0.rawValue.capitalized)")
                        }
                    }
                }
            }
            .navigationDestination(for: Int.self) { i in
                AddView()
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ExpenseItem.self, configurations: config)
        return ContentView()
            .modelContainer(container)
    }
    catch {
        return Text("Could not create view: \(error.localizedDescription)")
    }
}
