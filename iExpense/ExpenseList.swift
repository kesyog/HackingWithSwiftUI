//
//  ExpenseList.swift
//  iExpense
//
//  Created by Kesavan Yogeswaran on 8/25/24.
//

import SwiftUI
import SwiftData

struct ExpenseList: View {
    @Query private var expenses: [ExpenseItem]
    @Environment(\.modelContext) var modelContext
    let expenseType: ExpenseType
    let sortOrder: [SortDescriptor<ExpenseItem>]
    
    init(expenseType: ExpenseType, sortOrder: [SortDescriptor<ExpenseItem>] = [SortDescriptor(\ExpenseItem.name)]) {
        self.expenseType = expenseType
        self.sortOrder = sortOrder
        let type = expenseType.rawValue
        
        _expenses = Query(filter: #Predicate<ExpenseItem> { expenseItem in
            expenseItem.type == type
        }, sort: sortOrder)
    }
    
    var body: some View {
        Section(expenseType.rawValue.capitalized) {
            ForEach(expenses) { item in
                HStack {
                    Text(item.name)
                        .font(.headline)
                    Spacer()
                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .foregroundStyle(styleAmount(item.amount))
                }
            }
            .onDelete(perform: { indexSet in
                for index in indexSet {
                    modelContext.delete(expenses[index])
                }
            })
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ExpenseItem.self, configurations: config)
        container.mainContext.insert(ExpenseItem(name: "1234", type: .personal, amount: 123))
        container.mainContext.insert(ExpenseItem(name: "1234", type: .business, amount: 123))
        return ExpenseList(expenseType: .personal)
            .modelContainer(container)
    }
    catch {
        return Text("Could not create view: \(error.localizedDescription)")
    }
}
