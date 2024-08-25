//
//  ContentView.swift
//  WeSplit
//
//  Created by Kesavan Yogeswaran on 7/8/24.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [10, 15, 20, 25, 0]
    var totalAmount: Double {
        checkAmount * (1.0 + Double(tipPercentage) / 100.0)
    }
    var amountPerPerson: Double {
        totalAmount / Double(numberOfPeople)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.autoupdatingCurrent.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people").tag($0)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                Section("How much tip do you want to leave?") {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0..<101) {
                            Text($0, format: .percent)
                        }
                    }.pickerStyle(.navigationLink)
                }
                Section("Total amount") {
                    Text(totalAmount, format: .currency(code: Locale.autoupdatingCurrent.currency?.identifier ?? "USD"))
                        .foregroundStyle(tipPercentage == 0 ? .red : .primary)
                }
                Section("Amount per person") {
                    Text(amountPerPerson, format: .currency(code: Locale.autoupdatingCurrent.currency?.identifier ?? "USD"))
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
