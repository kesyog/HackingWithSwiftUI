//
//  AstronautScrollView.swift
//  Moonshot
//
//  Created by Kesavan Yogeswaran on 8/3/24.
//

import SwiftUI

struct AstronautScrollView: View {
    let crew: [MissionView.CrewMember]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crew, id: \.astronaut.id) { crewMember in
                    NavigationLink(value: crewMember.astronaut) {
                        HStack {
                            Image(crewMember.astronaut.id)
                                .resizable()
                                .frame(width: 104, height: 72)
                                .clipShape(.capsule)
                                .overlay(
                                    Capsule()
                                        .strokeBorder(crewMember.role == "Commander" ? .pink : .white, lineWidth: 1)
                                )
                            VStack(alignment: .leading) {
                                Text(crewMember.astronaut.name)
                                    .foregroundStyle(.white)
                                    .font(.headline)
                                Text(crewMember.role)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationDestination(for: Astronaut.self) {
                AstronautView(astronaut: $0)
            }
        }
    }
}

#Preview {
    AstronautScrollView(crew: [])
}
