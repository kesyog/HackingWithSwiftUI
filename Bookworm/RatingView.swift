//
//  RatingView.swift
//  Bookworm
//
//  Created by Kesavan Yogeswaran on 8/19/24.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    
    var label = ""
    
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            if !label.isEmpty {
                Text(label)
            }
            ForEach(1...maximumRating, id: \.self) { number in
                Button {
                    rating = number
                } label: {
                    if number <= rating {
                        onImage
                            .foregroundColor(onColor)
                    } else {
                        (offImage ?? onImage)
                            .foregroundColor(offColor)
                    }
                }
            }
        }
        .buttonStyle(.plain)
        
    }
}

#Preview {
    RatingView(rating: .constant(3))
}
