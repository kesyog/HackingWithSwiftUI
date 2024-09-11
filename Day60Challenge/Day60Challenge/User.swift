//
//  User.swift
//  Day60Challenge
//
//  Created by Kesavan Yogeswaran on 9/8/24.
//

import Foundation

struct User: Codable, Identifiable, Hashable {
    let id: UUID
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let registered: Date
    let friends: [Friend]
}

struct Friend: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
}
