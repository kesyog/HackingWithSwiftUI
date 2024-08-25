//
//  Book.swift
//  Bookworm
//
//  Created by Kesavan Yogeswaran on 8/19/24.
//

import Foundation
import SwiftData

enum Genre: String, CaseIterable, Codable {
    case fantasy, horror, kids, mystery, poetry, romance, thriller
}


@Model
class Book {
    var title: String
    var author: String
    var genre: Genre
    var review: String
    var rating: Int
    let addedDate: Date = Date.now
    
    init(title: String, author: String, genre: Genre, review: String, rating: Int) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
    }
}
