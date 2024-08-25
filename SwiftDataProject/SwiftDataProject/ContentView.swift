//
//  ContentView.swift
//  SwiftDataProject
//
//  Created by Kesavan Yogeswaran on 8/24/24.
//

import SwiftUI
import SwiftData

@Model
class Job {
    var name: String
    var priority: Int
    var owner: User?

    init(name: String, priority: Int, owner: User? = nil) {
        self.name = name
        self.priority = priority
        self.owner = owner
    }
}

@Model
class User {
    var name: String
    var city: String
    var joinDate: Date
    @Relationship(deleteRule: .cascade)
    var jobs = [Job]()
    
    init(name: String, city: String, joinDate: Date = Date.now) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<User> { user in
        user.name.localizedStandardContains("r") &&
        user.city == "London"
    }, sort: \User.name) var users: [User]
    @State private var path = [User]()
    @State private var showingUpcomingOnly = false
    @State private var sortOrder = [
        SortDescriptor(\User.name),
        SortDescriptor(\User.joinDate),
    ]
    
    var body: some View {
        NavigationStack(path: $path) {
            UsersView(minimumJoinDate: showingUpcomingOnly ? .now : .distantPast, sortOrder: sortOrder)
            .navigationTitle("Users")
            .navigationDestination(for: User.self) { user in
                EditUserView(user: user)
            }
            .toolbar {
                Button("Add User", systemImage: "gear") {
                    let user = User(name: "", city: "")
                    modelContext.insert(user)
                    path = [user]
                }
                Button("Add Samples", systemImage: "plus") {
                    try? modelContext.delete(model: User.self)
                    let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
                    let second = User(name: "Rosa Diaz", city: "New York", joinDate: .now.addingTimeInterval(86400 * -5))
                    let third = User(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
                    let fourth = User(name: "Johnny English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))
                    let job1 = Job(name: "Organize sock drawer", priority: 3)
                    let job2 = Job(name: "Make plans with Alex", priority: 4)
                    first.jobs.append(contentsOf: [job1, job2])
                    
                    modelContext.insert(first)
                    modelContext.insert(second)
                    modelContext.insert(third)
                    modelContext.insert(fourth)
                }
                Button(showingUpcomingOnly ? "Show everyone" : "Show upcoming") {
                    showingUpcomingOnly.toggle()
                }
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort by Name")
                            .tag([
                                SortDescriptor(\User.name),
                                SortDescriptor(\User.joinDate),
                            ])
                        
                        Text("Sort by Join Date")
                            .tag([
                                SortDescriptor(\User.joinDate),
                                SortDescriptor(\User.name)
                            ])
                    }
                }
            }
        }
       
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: User.self, configurations: config)
        return ContentView()
            .modelContainer(container)
    }
    catch {
        return Text("Could not create view: \(error.localizedDescription)")
    }
}
