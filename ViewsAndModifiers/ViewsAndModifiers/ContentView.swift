//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Kesavan Yogeswaran on 7/14/24.
//

import SwiftUI

struct AddBorder: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.red)
            .padding()
            .background(.blue)
            .padding()
            .background(.green)
            .padding()
            .background(.yellow)
    }
}

extension View {
    func addBorder() -> some View {
        self.modifier(AddBorder())
    }
}

struct ContentView: View {
    var body: some View {
        Button("Hello, world!") {
            print(type(of: self.body))
        }
        .background(.red)
        .frame(width: 200, height: 200)
        .addBorder()
        Text("Hello, world!").addBorder().kabluey()
    }
}

struct BigBlue: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.blue)
            .font(.largeTitle)
    }
}

extension View {
    func kabluey() -> some View {
        self.modifier(BigBlue())
    }
}

#Preview {
    ContentView()
}
