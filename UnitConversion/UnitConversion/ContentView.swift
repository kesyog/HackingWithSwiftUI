//
//  ContentView.swift
//  UnitConversion
//
//  Created by Kesavan Yogeswaran on 7/11/24.
//

import SwiftUI

enum DistanceUnits: String, CaseIterable {
    case meters, kilometers, feet, yards, miles
    
    func meters_multiplier() -> Double {
        switch self {
            case .meters:
                1.0
            case .kilometers:
                0.001
            case .feet:
                12.0 * 2.54 * 0.001
            case .yards:
                12.0 * 2.54 * 0.001 / 3
            case .miles:
                1.0 / 1609.0
        }
    }
}

struct ContentView: View {
    @State var sourceUnits = DistanceUnits.meters
    @State var targetUnits = DistanceUnits.kilometers
    @State var sourceAmount = 0.0
    var targetAmount: Double {
        sourceAmount / sourceUnits.meters_multiplier() * targetUnits.meters_multiplier()
    }
    
    var body: some View {
        Form {
            Section("Source") {
                Picker("Units", selection: $sourceUnits) {
                    ForEach(DistanceUnits.allCases, id: \.self) {
                        Text("\($0)".capitalized)
                    }
                }
                .pickerStyle(.segmented)
                TextField("Amount", value: $sourceAmount, format: .number)
                    .keyboardType(.decimalPad)
            }
            Section("Target") {
                Picker("Target Units", selection: $targetUnits) {
                    ForEach(DistanceUnits.allCases.filter {$0 != sourceUnits}, id: \.self) {
                        Text("\($0)".capitalized)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: sourceUnits) {
                    if sourceUnits == targetUnits {
                        targetUnits = DistanceUnits.allCases.filter {$0 != sourceUnits}[0]
                    }
                }

                Text(targetAmount, format: .number)
            }
        }
    }
}

#Preview {
    ContentView()
}
