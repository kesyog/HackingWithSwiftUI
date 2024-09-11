//
//  UserDetailView.swift
//  Day60Challenge
//
//  Created by Kesavan Yogeswaran on 9/8/24.
//

import SwiftUI

struct UserDetailView: View {
    let user: User
    
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
                    Text(friend.name)
                }
            }
        }
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    struct AsyncTestView: View {
        @State var users = [User]()
        
        var body: some View {
            if users.isEmpty {
                Text("Loading...")
                    .task {
                        users = await fetchData()
                    }
            } else {
                UserDetailView(user: users[0])
            }
        }
    }
    
    return AsyncTestView()
}
