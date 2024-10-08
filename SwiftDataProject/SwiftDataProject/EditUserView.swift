//
//  EditUserView.swift
//  SwiftDataProject
//
//  Created by Kesavan Yogeswaran on 8/24/24.
//

import SwiftUI
import SwiftData

struct EditUserView: View {
    @Bindable var user: User
    
    var body: some View {
        Form {
            TextField("Name", text: $user.name)
            TextField("City", text: $user.city)
            DatePicker("Join Date", selection: $user.joinDate)
        }
        .navigationTitle("Edit User")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: User.self, configurations: config)
        let user = User(name: "", city: "")
        return EditUserView(user: user)
            .modelContainer(container)
    }
    catch {
        return Text("Could not create view: \(error.localizedDescription)")
    }
}
