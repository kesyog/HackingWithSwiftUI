//
//  AddActivityView.swift
//  HabitTracker
//
//  Created by Kesavan Yogeswaran on 8/10/24.
//

import SwiftUI

struct AddActivityView: View {
    let activitiesList: ActivityList
    @State private var name = ""
    @State private var description = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section("Name") {
                TextField("Name", text: $name)
            }
            Section("Description") {
                TextField("Description", text: $description)
            }
            Button("Add") {
                let newActivity = Activity(name: name, description: description)
                activitiesList.list.append(newActivity)
                dismiss()
            }
        }
        .navigationTitle("Add new habit")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddActivityView(activitiesList: ActivityList())
}
