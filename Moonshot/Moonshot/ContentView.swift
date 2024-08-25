//
//  ContentView.swift
//  Moonshot
//
//  Created by Kesavan Yogeswaran on 7/31/24.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let layout = [GridItem(.adaptive(minimum: 150))]
    @State var showList = false
    
    var body: some View {
        NavigationStack {
            Group {
                if showList {
                    List {
                        ForEach(missions) { mission in
                            NavigationLink(value: mission) {
                                MissionLink(mission: mission)
                            }
                        }
                        .listRowBackground(Color.darkBackground)
                    }
                    .listStyle(.plain)
                } else {
                    ScrollView {
                        LazyVGrid(columns: layout) {
                            ForEach(missions) { mission in
                                NavigationLink(value: mission) {
                                    MissionLink(mission: mission)
                                }
                            }
                        }
                    }
                    .padding([.horizontal, .bottom])
                }
            }
            .navigationDestination(for: Mission.self) { mission in
                MissionView(mission: mission, astronauts: astronauts)
            }
            .background(.darkBackground)
            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
            .navigationTitle("Moonshot")
            .toolbar {
                Toggle("Show list", isOn: $showList)
                    .toggleStyle(.switch)
            }
        }
    }
}

#Preview {
    ContentView()
}
