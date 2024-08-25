//
//  AddBookView.swift
//  Bookworm
//
//  Created by Kesavan Yogeswaran on 8/19/24.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.modelContext) var modelContext
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = Genre.fantasy
    @State private var review = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                        .autocorrectionDisabled()
                    TextField("Author's name", text: $author)
                        .autocorrectionDisabled()
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(Genre.allCases, id: \.self) { genre in
                            Text(genre.rawValue.capitalized)
                        }
                    }
                }
                
                Section("Write a review") {
                    TextEditor(text: $review)
                    
                    HStack {
                        Text("Rating:")
                            .padding(.trailing)
                        RatingView(rating: $rating)
                        .pickerStyle(.palette)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                Section {
                    Button("Save") {
                        let newBook = Book(title: title, author: author, genre: genre, review: review, rating: rating)
                        modelContext.insert(newBook)
                        dismiss()
                    }
                    .disabled(title.isEmpty || author.isEmpty || review.isEmpty)
                }
            }
            .navigationTitle("Add book")
        }
    }
}

#Preview {
    AddBookView()
}
