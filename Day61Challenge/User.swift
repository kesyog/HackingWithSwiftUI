//
//  User.swift
//  Day61Challenge
//
//  Created by Kesavan Yogeswaran on 9/10/24.
//

import Foundation
import SwiftData

@Model
class User: Codable, Identifiable, Hashable {
    let id: UUID
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let registered: Date
    let friends: [Friend]
    
    init(id: UUID, isActive: Bool, name: String, age: Int, company: String, email: String, registered: Date, friends: [Friend]) {
        self.id = id
        self.isActive = isActive
        self.name = name
        self.age = age
        self.company = company
        self.email = email
        self.registered = registered
        self.friends = friends
    }
    
    enum CodingKeys: CodingKey {
        case id
        case isActive
        case name
        case age
        case company
        case email
        case registered
        case friends
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID(uuidString: try container.decode(String.self, forKey: .id))!
        self.isActive = try container.decode(Bool.self, forKey: .isActive)
        self.name = try container.decode(String.self, forKey: .name)
        self.age = try container.decode(Int.self, forKey: .age)
        self.company = try container.decode(String.self, forKey: .company)
        self.email = try container.decode(String.self, forKey: .email)
        self.registered = try container.decode(Date.self, forKey: .registered)
        self.friends = try container.decode([Friend].self, forKey: .friends)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.isActive, forKey: .isActive)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.age, forKey: .age)
        try container.encode(self.company, forKey: .company)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.registered, forKey: .registered)
        try container.encode(self.friends, forKey: .friends)
    }
}

@Model
class Friend: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    
    enum CodingKeys: CodingKey {
        case id
        case name
    }
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID(uuidString: try container.decode(String.self, forKey: .id))!
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
    }
}
