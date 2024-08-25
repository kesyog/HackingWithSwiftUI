//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Kesavan Yogeswaran on 8/17/24.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                    .autocorrectionDisabled()
                TextField("Street address", text: $order.streetAddress)
                    .autocorrectionDisabled()
                TextField("City", text: $order.city)
                    .autocorrectionDisabled()
                TextField("Zip", text: $order.zip)
                    .autocorrectionDisabled()
            }
            Section {
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                }
            }
            .disabled(!order.hasValidAddress)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddressView(order: Order())
}
