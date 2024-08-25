//
//  ContentView.swift
//  WordScramble
//
//  Created by Kesavan Yogeswaran on 7/20/24.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord: String? = nil
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var score = 0
    @FocusState private var isTextFieldFocused
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        TextField("Enter your word",
                                  text: Binding(
                                    get: {newWord ?? ""},
                                    set: {newWord = $0.isEmpty ? nil : $0}))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .onSubmit(addNewWord)
                        .focused($isTextFieldFocused)
                    }
                }
                
                Section("Score") {
                    Text("\(score)")
                }
                
                Section("Found words") {
                    if usedWords.isEmpty {
                        Text("")
                    }
                    ForEach(usedWords.reversed(), id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .toolbar {
                Button("New word", action: startGame)
                    .buttonStyle(.borderedProminent)
            }
        }
        .onAppear(perform: startGame)
        .alert(errorTitle, isPresented: $showingError) {} message: {
            Text(errorMessage)
        }
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: ".txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: .whitespacesAndNewlines)
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
    
    func addNewWord() {
        isTextFieldFocused = true
        guard let answer = newWord?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        guard !answer.isEmpty else {
            return
        }
        newWord = nil
        guard answer != rootWord else {
            wordError(title: "That's our word", message: "Make up your own words")
            return
        }
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard answer.count >= 3 else {
            wordError(title: "Word not long enough", message: "Words must be at least 3 letters.")
            return
        }
        
        score += answer.count
        
        withAnimation {
            usedWords.append(answer)
        }
        isTextFieldFocused = true
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var rootWordClone = rootWord
        for letter in word {
            guard let i = rootWordClone.firstIndex(of: letter) else {
                return false
            }
            rootWordClone.remove(at: i)
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview {
    ContentView()
}
