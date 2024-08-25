//
//  Activity.swift
//  HabitTracker
//
//  Created by Kesavan Yogeswaran on 8/7/24.
//

import Foundation

struct Activity: Codable, Hashable, Identifiable, Equatable {
    var id = UUID()
    var name: String
    let description: String
    var count = 0
    
    mutating func increment() {
        self.count += 1
    }
}
