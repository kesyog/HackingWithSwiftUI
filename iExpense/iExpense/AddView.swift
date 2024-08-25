//
//  AddView.swift
//  iExpense
//
//  Created by Kesavan Yogeswaran on 7/30/24.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = ExpenseType.personal
    @State private var amount = 0.0
    @Environment(\.dismiss) var dismiss
    var expenses: Expenses
    
    var body: some View {
        Form {
            TextField("Expense Name", text: $name)
            
            Picker("Type", selection: $type) {
                ForEach(ExpenseType.allCases, id: \.self) {
                    Text($0.rawValue.capitalized)
                }
            }.pickerStyle(.segmented)
            
            TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .keyboardType(.decimalPad)
            
            Button("Add") {
                expenses.items.append(ExpenseItem(name: name, type: type, amount: amount))
                dismiss()
            }
        }
        .navigationTitle("Add new expense")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    expenses.items.append(ExpenseItem(name: name, type: type, amount: amount))
                    dismiss()
                }.foregroundStyle(.red)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    AddView(expenses: Expenses())
}
