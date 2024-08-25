//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Kesavan Yogeswaran on 7/16/24.
//

import SwiftUI

let nTurns = 10
let rolls = ["Rock", "Paper", "Scissors"]
enum Roll: String, CaseIterable {
    case rock, paper, scissors
    
    func asEmoji() -> String {
        switch self {
        case .rock:
            return "🪨"
        case .paper:
            return "📄"
        case .scissors:
            return "✂️"
        }
    }
}

struct ContentView: View {
    @State var goalIsWin = Bool.random()
    @State var nTurnsElapsed = 0
    @State var score = 0
    @State var myThrow = Roll.allCases.randomElement()!
    @State var gameOver = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.cyan, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .opacity(0.7)
            VStack {
                Spacer()
                Text("I threw \(myThrow)")
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                Text("Try to \(goalIsWin ? "win" : "lose")")
                HStack {
                    ForEach(Roll.allCases, id: \.self) { roll in
                        Button(roll.asEmoji()) {
                            if evaluateThrow(roll) {
                                score += 1
                            } else {
                                score -= 1
                            }
                            nTurnsElapsed += 1
                            myThrow = Roll.allCases.randomElement()!
                            goalIsWin.toggle()
                            if nTurnsElapsed == nTurns {
                                gameOver = true
                            }
                        }
                            .font(.system(size: 75))
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.roundedRectangle)
                            .padding(5)
                    }
                }
                Text("Your score: \(score)")
                Spacer()
                Spacer()
                Spacer()
            }
        }
        .alert("Game over", isPresented: $gameOver) {
            Button("New game", action: resetGame)
        } message: {
            Text("Your score was \(score). Good job!")
        }
    }
    
    func resetGame() {
        nTurnsElapsed = 0
        score = 0
    }
    
    func evaluateThrow(_ yourThrow: Roll) -> Bool {
        if yourThrow == myThrow {
            return false
        }
        switch yourThrow {
        case .rock:
            return (myThrow == .scissors) == goalIsWin
        case .scissors:
            return (myThrow == .paper) == goalIsWin
        case .paper:
            return (myThrow == .rock) == goalIsWin
        }
    }
}

#Preview {
    ContentView()
}
