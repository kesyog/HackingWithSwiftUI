//
//  Mission.swift
//  Moonshot
//
//  Created by Kesavan Yogeswaran on 8/1/24.
//

import Foundation

struct Mission: Codable, Identifiable, Hashable {
    var displayName: String {
        "Apollo \(id)"
    }
    var image: String {
        "apollo\(id)"
    }
    var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
        //launchDate ?? "N/A"
    }
    
    struct CrewRole: Codable, Hashable {
        let name: String
        let role: String
    }
    
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
}
