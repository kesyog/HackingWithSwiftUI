//
//  UsersView.swift
//  SwiftDataProject
//
//  Created by Kesavan Yogeswaran on 8/25/24.
//

import SwiftUI
import SwiftData

struct UsersView: View {
    @Query var users: [User]
    
    init(minimumJoinDate: Date, sortOrder: [SortDescriptor<User>] = [SortDescriptor(\User.name)]) {
        _users = Query(filter: #Predicate<User> {user in
            user.joinDate >= minimumJoinDate
        }, sort: sortOrder)
    }
    
    var body: some View {
        List(users) { user in
            NavigationLink(value: user) {
                Text(user.name)
                Spacer()

                Text(String(user.jobs.count))
                    .fontWeight(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }
        }
    }
}

#Preview {
    UsersView(minimumJoinDate: .now)
        .modelContainer(for: User.self)
}
