//
//  UserDetailView.swift
//  Day10Challenge
//
//  Created by Kesavan Yogeswaran on 9/8/24.
//

import SwiftUI
import SwiftData

struct UserDetailView: View {
    let user: User
    @Query var users: [User]
    
    var body: some View {
        List {
            Section("User") {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(user.name), \(user.age)")
                        if !user.isActive {
                            Text("(inactive)")
                        }
                    }
                    Link(user.email, destination: URL(string: "mailto:\(user.email)")!)
                    Text("Joined \(user.registered.formatted(date: .long, time: .omitted))")
                }
            }
            
            Section("Company") {
                Text(user.company)
            }
            Section("Friends") {
                ForEach(user.friends) { friend in
                    if let user = users.filter({ $0.id == friend.id }).first {
                        return AnyView(NavigationLink(friend.name, value: user))
                    } else {
                        return AnyView(Text(friend.name))
                    }
                }
            }
        }
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.large)
        // Must be outside the List because of the laziness of List
        .navigationDestination(for: User.self) { user in
            UserDetailView(user: user)
        }
    }
}

#Preview {
    struct AsyncTestView: View {
        @Environment(\.modelContext) var modelContext
        @Query private var users: [User]
        
        var body: some View {
            if users.isEmpty {
                Text("Loading...")
                    .task {
                        for user in await fetchData() {
                            modelContext.insert(user)
                        }
                    }
            } else {
                UserDetailView(user: users[0])
            }
        }
    }
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: User.self, configurations: config)
        return AsyncTestView()
            .modelContainer(container)
    }
    catch {
        return Text("Could not create view: \(error.localizedDescription)")
    }
}
