//
//  ContentView.swift
//  TimesTable
//
//  Created by Kesavan Yogeswaran on 7/26/24.
//

import SwiftUI

struct ContentView: View {
    @State var numQuestions = 10
    @State var multiplicandUpperBound = 5
    @State var preGame = true
    @State var answer = 0
    @State var score = 0
    @State var gameOver = false
    
    private let quantityFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .none
            formatter.zeroSymbol = ""
            return formatter
        }()
    
    var body: some View {
        NavigationStack {
            VStack {
                if (preGame) {
                    StartupView {
                        numQuestions = $0
                        multiplicandUpperBound = $1
                        withAnimation {
                            preGame = false
                        }
                    }
                } else {
                    GameView(numQuestions: numQuestions, multiplicandUpperBound: multiplicandUpperBound, onGameOver: { score in
                        self.score = score
                        gameOver = true
                    }, onReset: newGame)
                }
            }
            .navigationTitle("TimesTable")
            .alert("Game over", isPresented: $gameOver) {
                Button("Ok") {
                    preGame = true
                }
            } message: {
                Text("Your score was \(score) / \(numQuestions)")
            }
        }
    }

    
    func newGame() {
        preGame = true
        score = 0
    }
}

struct StartupView: View {
    let onStart: (Int, Int) -> ()
    @State var numQuestions = 10
    @State var multiplicandUpperBound = 5
    
    var body: some View {
        Form {
            Stepper(value: $numQuestions, in: 5...20, step: 5) {
                HStack {
                    Text("How many questions?")
                    Spacer()
                    Text("\(numQuestions)")
                }
            }
            Stepper(value: $multiplicandUpperBound, in: 2...12) {
                HStack {
                    Text("Up to...")
                    Spacer()
                    Text("\(multiplicandUpperBound)x\(multiplicandUpperBound)")
                }
            }
            Button("Start") {
                onStart(numQuestions, multiplicandUpperBound)
            }
            .buttonStyle(.bordered)
        }
    }
}

struct GameView: View {
    let numQuestions: Int
    let multiplicandUpperBound: Int
    let onGameOver: (Int) -> ()
    let onReset: () -> ()
    
    init(numQuestions: Int, multiplicandUpperBound: Int, onGameOver: @escaping (Int) -> (), onReset: @escaping () -> ()) {
        self.numQuestions = numQuestions
        self.multiplicandUpperBound = multiplicandUpperBound
        self.onGameOver = onGameOver
        self.onReset = onReset
        self.multiplier1 = Int.random(in: 1..<multiplicandUpperBound)
        self.multiplier2 = Int.random(in: 1..<multiplicandUpperBound)
    }
    
    @State var numQuestionsAsked = 0
    @State var multiplier1: Int
    @State var multiplier2: Int
    @State var score = 0
    @State var enteredAnswer = 0
    @State var promptRotation = 0.0
    @State var correct: Bool? = nil
    @FocusState var textFieldFocused
    private let quantityFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .none
            formatter.zeroSymbol = ""
            return formatter
        }()
    
    var body: some View {
        Spacer()
        ZStack {
            Color.red
                .frame(height: 300)
                .opacity(0.75)
            VStack {
                Text("\(multiplier1) x \(multiplier2)")
                    .font(.largeTitle)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding()
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(promptRotation))
                    .animation(.default, value: promptRotation)
                Section("Your answer:") {
                    TextField("Answer", value: $enteredAnswer, formatter: quantityFormatter)
                        .keyboardType(.numberPad)
                        .foregroundColor(.white)
                        .font(.title)
                        .padding()
                        .border(Color.white)
                        .onSubmit(onSubmit)
                        .focused($textFieldFocused)
                        .onAppear {
                            textFieldFocused = true
                        }
                }
                .foregroundStyle(.white)
                HStack {
                    Spacer()
                    Button("Submit") {
                        onSubmit()
                    }
                        .padding([.trailing])
                        .foregroundColor(.white)
                        .buttonStyle(.borderedProminent)
                }
            }
        }
        if let correct {
            Text(correct ? "Correct!" : "Incorrect!")
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundStyle(correct ? .green : .red)
        }
        Spacer()
        Text("Score: \(score)")
            .font(.headline)
            .animation(.default, value: score)
        .toolbar(content: {
            Button("New game") {
                onReset()
            }
        })
    }
    
    func onSubmit() {
        guard enteredAnswer != 0 else {
            return
        }
        if enteredAnswer == multiplier1 * multiplier2 {
            score += 1
            correct = true
        } else {
            correct = false
        }
        numQuestionsAsked += 1
        if numQuestionsAsked == numQuestions {
            onGameOver(score)
            return
        }
        withAnimation(.easeInOut) {
            newPrompt()
            promptRotation += 360
        }
    }
    
    func newPrompt() {
        enteredAnswer = 0
        let oldMultiplier1 = multiplier1
        let oldMultiplier2 = multiplier2
        repeat {
            multiplier1 = Int.random(in: 1..<multiplicandUpperBound)
            multiplier2 = Int.random(in: 1..<multiplicandUpperBound)
            print("\(oldMultiplier1) \(oldMultiplier2) \(multiplier1) \(multiplier2)")
        } while multiplier1 == oldMultiplier1 && multiplier2 == oldMultiplier2
        textFieldFocused = true
    }
}

#Preview {
    ContentView()
}
