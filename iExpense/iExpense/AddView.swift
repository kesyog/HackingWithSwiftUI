//
//  AddView.swift
//  iExpense
//
//  Created by Kesavan Yogeswaran on 7/30/24.
//

import SwiftUI
import SwiftData

struct AddView: View {
    @State private var name = ""
    @State private var type = ExpenseType.personal
    @State private var amount = 0.0
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            TextField("Expense Name", text: $name)
                .autocorrectionDisabled()
            
            Picker("Type", selection: $type) {
                ForEach(ExpenseType.allCases, id: \.self) {
                    Text($0.rawValue.capitalized)
                }
            }.pickerStyle(.segmented)
            
            TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .keyboardType(.decimalPad)
                .autocorrectionDisabled()
            
            Button("Add") {
                modelContext.insert(ExpenseItem(name: name, type: type, amount: amount))
                dismiss()
            }
            .disabled(name.isEmpty)
        }
        .navigationTitle("Add new expense")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }.foregroundStyle(.red)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ExpenseItem.self, configurations: config)
        return AddView()
            .modelContainer(container)
    }
    catch {
        return Text("Could not create view: \(error.localizedDescription)")
    }
}
