//
//  ContentView.swift
//  iExpense
//
//  Created by Kesavan Yogeswaran on 7/29/24.
//

import SwiftUI

enum ExpenseType: String, Codable, CaseIterable {
    case personal, business
}

struct ExpenseItem: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
    let type: ExpenseType
    let amount: Double
}

@Observable
class Expenses {
    var items: [ExpenseItem] {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
                print("did set")
            }
        }
    }
    
    init() {
        guard let savedItems = UserDefaults.standard.data(forKey: "Items") else {
            items = []
            return
        }
        guard let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) else {
            items = []
            return
        }
        items = decodedItems.filter { !$0.name.isEmpty }
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

extension Array where Element == ExpenseItem {
    func filter(by typeFilter: ExpenseType) -> [ExpenseItem] {
        self.filter { $0.type == typeFilter }
    }
    
    mutating func removeFilteredItems(typeFilter: ExpenseType, atOffsets toRemove: IndexSet) {
        var filteredItems = self.filter(by: typeFilter)
        filteredItems.remove(atOffsets: toRemove)
        self.removeAll { item in
            item.type == typeFilter && !filteredItems.contains([item])
        }
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(ExpenseType.allCases, id: \.self) { expenseType in
                    Section(expenseType.rawValue.capitalized) {
                        ForEach(expenses.items.filter(by: expenseType)) { item in
                            HStack {
                                Text(item.name)
                                    .font(.headline)
                                Spacer()
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .foregroundStyle(styleAmount(item.amount))
                            }
                        }
                        .onDelete(perform: { indexSet in
                            expenses.items.removeFilteredItems(typeFilter: expenseType, atOffsets: indexSet)
                        })
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink(value: 0) {
                    Image(systemName: "plus")
                }
            }
            .navigationDestination(for: Int.self) { i in
                AddView(expenses: expenses)
            }
        }
    }
}

#Preview {
    ContentView()
}
