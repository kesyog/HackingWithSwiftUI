//
//  ContentView.swift
//  Navigation
//
//  Created by Kesavan Yogeswaran on 8/4/24.
//

import SwiftUI

struct DetailView: View {
    @Binding var path: NavigationPath
    var number: Int

    var body: some View {
        NavigationLink("Go to Random Number", value: Int.random(in: 1...1000))
            .navigationTitle("Number: \(number)")
            .toolbar {
                Button("root") {
                    path = NavigationPath()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
    }
}
struct ContentView: View {
    @State private var path = NavigationPath()
    @State private var title = "title"
    
    var body: some View {
        NavigationStack(path: $path) {
            List(0..<100) { i in
                Text("Row \(i)")
            }
            .navigationTitle($title)
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

#Preview {
    ContentView()
}
