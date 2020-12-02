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
            VStack(spacing: 40) {
                VStack(spacing: 20) {
                    Text("How many multiplication tables do you know?")
                        .gameTitleStyle(color: Color.red)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    VStack(spacing: 5) {
                        Text("\(tableCount)")
                            .gameTitleStyle(color: Color.green)
                        Stepper(value: $tableCount, in: 1...12) {
                            Text("\(tableCount)")
                        }
                        .labelsHidden()
                    }
                }
                
                VStack(spacing: 20) {
                    Text("How many questions should I ask you?")
                        .gameTitleStyle(color: Color.blue)
                    Picker("No of questions", selection: $noOfQuestionsIndex, content: {
                        ForEach(0 ..< noOfQuestions.count) {
                            Text(noOfQuestions[$0])
                        }
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(EdgeInsets(top: 3, leading: 50, bottom: 5, trailing: 50))
                }
                
                HStack{
                    Spacer()
                    Button(action: createQuestions, label: {
                        Text("Start Playing")
                            .gameTitleStyle(color: Color.white)
                            
                    })
                    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                    .background(Color.yellow)
                    .clipShape(Capsule())
                    Spacer()
                }
            }
            .navigationTitle("Edutainment")
            .navigate(to: GameView(allQs: questions), navBarTitle: "Game Show", when: $showingGame)
        }
    }
    
    func createQuestions() {
        var allQuestions = [String]()
        for firstIndex in 1...tableCount {
            for secondIndex in 1...tableCount {
                allQuestions.append("\(firstIndex) x \(secondIndex)")
            }
        }
        allQuestions.shuffle()
        if let requiredQuestions = Int(noOfQuestions[noOfQuestionsIndex]) {
            questions = Array(allQuestions.prefix(requiredQuestions))
        } else {
            questions = allQuestions
        }
        print("questions: ", questions)
        showingGame = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, navBarTitle: String, when binding: Binding<Bool>) -> some View {
        ZStack {
            self
            NavigationLink(
                destination: view
                    .navigationBarTitle(navBarTitle)
                    .navigationBarHidden(false),
                isActive: binding
            ) {
                EmptyView()
            }
        }
    }
}
