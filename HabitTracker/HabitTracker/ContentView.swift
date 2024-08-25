//
//  ContentView.swift
//  HabitTracker
//
//  Created by Kesavan Yogeswaran on 8/7/24.
//

import SwiftUI

@Observable
class ActivityList {
    var list: [Activity] {
        didSet {
            if let encoded = try? JSONEncoder().encode(list) {
                UserDefaults.standard.set(encoded, forKey: "Activities")
            }
        }
    }
    
    init() {
        list = []
        guard let savedData = UserDefaults.standard.data(forKey: "Activities") else {
            return
        }
        guard let savedList = try? JSONDecoder().decode([Activity].self, from: savedData) else {
            return
        }
        list = savedList
    }
}

struct ContentView: View {
    @State private var activities = ActivityList()
    @State private var showAddNewActivity = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Activities") {
                    if activities.list.isEmpty {
                        Text("None")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(Array(activities.list), id: \.self) { activity in
                            NavigationLink {
                                ActivityDetailView(activities: activities, activity: activity)
                            } label: {
                                HStack {
                                    Text(activity.name)
                                    Spacer()
                                    Text("Count: \(activity.count)")
                                }
                            }
                        }
                        .onDelete { offsets in
                            activities.list.removeFirst()
                        }
                    }
                }
                
            }
            .listStyle(.insetGrouped)
            .navigationTitle("HabitTracker")
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button("Delete all", role: .destructive) {
                        activities.list.removeAll()
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("Add new habit") {
                        showAddNewActivity = true
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                }
            }
            .toolbar {
                EditButton()
            }
            .sheet(isPresented: $showAddNewActivity) {
                AddActivityView(activitiesList: activities)
            }
        }
    }
}

#Preview {
    ContentView()
}
