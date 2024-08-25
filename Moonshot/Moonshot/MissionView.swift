//
//  MissionVIew.swift
//  Moonshot
//
//  Created by Kesavan Yogeswaran on 8/2/24.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let astronauts: [String: Astronaut]
    let crew: [CrewMember]
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission
        self.astronauts = astronauts
        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { width, _ in
                        width * 0.6
                    }
                    .padding(.top)
                if let launchDate = mission.launchDate {
                    Text(launchDate.formatted(date: .complete, time: .omitted))
                }
                VStack(alignment: .leading) {
                    ContentDivider()
                    Text("Mission Highlights")
                        .font(.title.bold())
                    Text(mission.description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ContentDivider()
                    Text("Crew")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                }
                .padding(.horizontal)
                AstronautScrollView(crew: crew)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom)
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

    return MissionView(mission: missions[1], astronauts: astronauts)
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
