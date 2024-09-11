//
//  ContentView.swift
//  Day60Challenge
//
//  Created by Kesavan Yogeswaran on 9/8/24.
//

import SwiftUI

struct ContentView: View {
    @State private var users = [User]()
    
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
                users = await fetchData()
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
    ContentView()
}
