//
//  ContentView.swift
//  BetterRest
//
//  Created by Kesavan Yogeswaran on 7/17/24.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    @State private var sleepTime: Date = Date.now
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: [.hourAndMinute])
                        .labelsHidden()
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper("😴 \(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    Picker("Coffee intake", selection: $coffeeAmount) {
                        ForEach(0..<11) {
                            Text("^[\($0) cup](inflect: true)")
                        }
                    }.labelsHidden()
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Suggested bedtime")
                        .font(.headline)
                    let bedtime = calculateBedtime()
                    Text("\(bedtime?.formatted(date: .omitted, time: .shortened) ?? "Unknown")")
                        .font(.title3)
                }
            }
            .navigationTitle("BetterRest")
        }
    }

    func calculateBedtime() -> Date? {
            let config = MLModelConfiguration()
            let model = try? SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
        guard let prediction = try? model?.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount)) else {
            return nil
        }
            return wakeUp - prediction.actualSleep
    }
}

#Preview {
    ContentView()
}
