//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Kesavan Yogeswaran on 8/16/24.
//

import SwiftUI

@Observable
class Order: Codable {
    enum Types: String, CaseIterable, Codable {
        case vanilla, strawberry, chocolate, rainbow
        
        var complexity: Decimal {
            Decimal(Types.allCases.firstIndex(of: self)!)
        }
    }
    
    init() {
        self.name = UserDefaults.standard.string(forKey: "name") ?? ""
        self.streetAddress = UserDefaults.standard.string(forKey: "streetAddress") ?? ""
        self.city = UserDefaults.standard.string(forKey: "city") ?? ""
        self.zip = UserDefaults.standard.string(forKey: "zip") ?? ""
    }
    
    var type = Types.vanilla
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if !specialRequestEnabled {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name: String {
        didSet {
            UserDefaults.standard.setValue(name, forKey: "name")
        }
    }
    var streetAddress = "" {
        didSet {
            UserDefaults.standard.setValue(streetAddress, forKey: "streetAddress")
        }
    }
    var city = "" {
        didSet {
            UserDefaults.standard.setValue(city, forKey: "city")
        }
    }
    var zip = "" {
        didSet {
            UserDefaults.standard.setValue(zip, forKey: "zip")
        }
    }
    var hasValidAddress: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var cost: Decimal {
        var cost = Decimal(quantity) * 2
        cost += type.complexity / 2
        if extraFrosting {
            cost += Decimal(quantity)
        }
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        return cost
    }
    
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
    }
}

struct ContentView: View {
    @State private var order = Order()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.type) {
                        ForEach(Order.Types.allCases, id: \.self) {
                            Text($0.rawValue.capitalized)
                        }
                    }
                    
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                Section {
                    Toggle("Any special requests?", isOn: $order.specialRequestEnabled)
                    if order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                }
                Section {
                    NavigationLink("Delivery Details") {
                        AddressView(order: order)
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

#Preview {
    ContentView()
}
