//
//  ContentView.swift
//  Edutainment
//
//  Created by Waveline Media on 12/1/20.
//

import SwiftUI

struct ContentView: View {
    
    @State private var noOfQuestions = ["5", "10", "15", "All"]
    @State private var noOfQuestionsIndex = 0
    @State private var tableCount = 1
    @State private var questions = [String]()
    @State private var showingGame = false
    
    var body: some View {
        NavigationView {
            VStack {
                if showingGame {
                    GameView(allQs: questions)
                } else {
                    Form {
                        Section(header: Text("I know multiplication tables upto: ")) {
                            Stepper(value: $tableCount, in: 1...12) {
                                Text("\(tableCount)")
                            }
                        }
                        Section(header: Text("How many questions to ask?")) {
                            Picker("Tip percentage", selection: $noOfQuestionsIndex, content: {
                                ForEach(0 ..< noOfQuestions.count) {
                                    Text(noOfQuestions[$0])
                                }
                            }).pickerStyle(SegmentedPickerStyle())
                        }
                        Section {
                            HStack{
                                Spacer()
                                Button(action: createQuestions, label: {
                                    Text("Start Playing")
                                })
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edutainment")
        }
    }
    
    func createQuestions() {
        var allQuestions = [String]()
        for firstIndex in 1...tableCount {
            for secondIndex in 1...tableCount {
                allQuestions.append("\(firstIndex)x\(secondIndex)")
            }
        }
        allQuestions.shuffle()
        if let requiredQuestions = Int(noOfQuestions[noOfQuestionsIndex]) {
            questions = Array(allQuestions.prefix(requiredQuestions))
        } else {
            questions = allQuestions
        }
        showingGame = true
    }
}

struct GameView: View {
    
    @State var allQs = [String]()
    @State var answer = ""
    @State var totalScore = 0
    @State var questionIndex = 0
    
    var body: some View {
        VStack {
            HStack {
                Text("Q\(questionIndex + 1): \(allQs[questionIndex])")
                TextField("\(allQs[questionIndex])", text: $answer, onCommit: calculateScore)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
            Text("Total Score: \(totalScore)")
        }
        .padding()
    }
    
    func calculateScore() {
        let numbers = allQs[questionIndex].lowercased().components(separatedBy: "x")
        if let lhs = Int(numbers.first ?? ""), let rhs = Int(numbers.last ?? "") {
            if let myAnswer = Int(answer) {
                if myAnswer == lhs * rhs {
                    totalScore += 1
                }
            }
        }
        answer = ""
        if questionIndex < allQs.count - 1 {
            questionIndex += 1
        } else {
            //Game has completed
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}
