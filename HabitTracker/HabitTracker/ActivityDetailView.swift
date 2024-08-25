//
//  ActivityDetailView.swift
//  HabitTracker
//
//  Created by Kesavan Yogeswaran on 8/7/24.
//

import SwiftUI

struct ActivityDetailView: View {
    @State var activities: ActivityList
    @State var activity: Activity
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            HStack {
                Text("Count: \(activity.count)")
                Spacer()
                Button("Increment", systemImage: "plus") {
                    if let index = activities.list.firstIndex(of: activity) {
                        activities.list[index].count += 1
                        activity.count += 1
                    }
                }
            }
            Text(activity.description)
        }
        .navigationTitle(activity.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let activities = ActivityList()
    return ActivityDetailView(activities: activities, activity: activities.list.first ?? Activity(name: "hello", description: "test"))
}
