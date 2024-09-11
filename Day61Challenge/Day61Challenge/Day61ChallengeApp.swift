//
//  Day61ChallengeApp.swift
//  Day61Challenge
//
//  Created by Kesavan Yogeswaran on 9/10/24.
//

import SwiftUI
import SwiftData

@main
struct Day61ChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
