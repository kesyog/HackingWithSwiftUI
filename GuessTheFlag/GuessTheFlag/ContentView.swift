//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Kesavan Yogeswaran on 7/12/24.
//

import SwiftUI

let countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
let nRounds = 8

struct ContentView: View {
    @State private var nCorrect = 0
    @State private var nIncorrect = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var displayed_countries = countries.shuffled()[0..<3]
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var messageText: String? = nil
    @State private var roundOfGame = 0
    @State private var showGameOverScreen = false
    @State private var flagPressed: Int? = nil

    private var correctCountry: String {
        displayed_countries[correctAnswer]
    }
    
    var body: some View {
        ZStack {
            AngularGradient(colors: [
                .blue, .teal, .cyan, .blue
            ], center: .center)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(displayed_countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            withAnimation {
                                flagPressed = number
                            }
                            flagTapped(number)
                        } label: {
                            if number == (flagPressed ?? number) {
                                FlagImage(country: displayed_countries[number])
                            } else {
                                FlagImage(country: displayed_countries[number])
                                    .grayscale(1)
                            }
                        }
                        .rotation3DEffect(
                            .degrees(number == flagPressed ? 360 : 0),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .opacity(number == (flagPressed ?? number) ? 1 : 0.25)
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(nCorrect) / \(nCorrect + nIncorrect)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }.padding()
        }.alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue") {
                if roundOfGame < nRounds {
                    askQuestion()
                } else {
                    showGameOverScreen = true
                }
            }
        } message: {
            Text("\(messageText ?? "Nice!") Your score is \(nCorrect) / \(nCorrect + nIncorrect)")
        }
        .alert("Game Over", isPresented: $showGameOverScreen) {
            Button("Continue") {
                roundOfGame = 0
                newGame()
            }
        } message: {
            Text("Game over! Your score is \(nCorrect) / \(nCorrect + nIncorrect)")
        }
    }
    
    func flagTapped(_ number: Int) {
        roundOfGame += 1
        if number == correctAnswer {
            nCorrect += 1
            scoreTitle = "Correct!"
            messageText = nil
        } else {
            nIncorrect += 1
            scoreTitle = "Incorrect"
            messageText = "Wrong! That's the flag of \(displayed_countries[number])."
        }
        showingScore = true
    }
    
    func askQuestion() {
        flagPressed = nil
        displayed_countries = countries.shuffled()[0..<3]
        correctAnswer = Int.random(in: 0...2)
    }
    
    func newGame() {
        flagPressed = nil
        roundOfGame = 0
        nCorrect = 0
        nIncorrect = 0
        askQuestion()
    }
}

struct FlagImage: View {
    let country: String
    
    var body: some View {
        Image(country)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
}
