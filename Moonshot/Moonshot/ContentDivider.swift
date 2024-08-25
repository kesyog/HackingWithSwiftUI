//
//  ContentDivider.swift
//  Moonshot
//
//  Created by Kesavan Yogeswaran on 8/3/24.
//

import SwiftUI

struct ContentDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.lightBackground)
            .padding(.vertical)
    }
}

#Preview {
    ContentDivider()
}
