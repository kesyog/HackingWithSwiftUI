//
//  ContentView.swift
//  Day61Challenge
//
//  Created by Kesavan Yogeswaran on 9/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var users: [User]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(users) { user in
                    NavigationLink(value: user) {
                        VStack {
                            if user.isActive {
                                Text(user.name)
                            } else {
                                Text(user.name)
                                    .italic()
                                    .fontWeight(.ultraLight)
                            }
                            
                        }
                    }
                }
            }
            .navigationDestination(for: User.self) { user in
                UserDetailView(user: user)
            }
        }
        .task {
            if users.isEmpty {
                for user in await fetchData() {
                    modelContext.insert(user)
                }
            }
        }
    }
}

func fetchData() async -> [User] {
    let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
    
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let users = try decoder.decode([User].self, from: data)
        print("Downloaded")
        return users
    } catch {
        print("Invalid data: \(error.localizedDescription)")
        return []
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
