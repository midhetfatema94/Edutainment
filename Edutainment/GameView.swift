//
//  GameView.swift
//  Edutainment
//
//

import SwiftUI

struct GameView: View {
    @State var allQs: [String] = []
    @State private var answer = ""
    @State private var totalScore = 0
    @State private var questionIndex = 0
    @State private var gameFinished = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Question No. \(questionIndex + 1)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text("\(allQs[questionIndex]) = ?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.purple)
                    .multilineTextAlignment(.center)
                TextField("\(allQs[questionIndex])", text: $answer, onCommit: calculateScore)
                    .font(.largeTitle)
                    .frame(width: 100, height: 100, alignment: .center)
                    .border(Color.gray, width: 2.0)
                    .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
                    .multilineTextAlignment(.center)
                Button(action: calculateScore, label: {
                    Text("Next Question")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        
                })
                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                .background(Color.blue)
                .clipShape(Capsule())
                Text("Total Score: \(totalScore)")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.yellow)
            }
        }
        .padding()
        .alert(isPresented: $gameFinished) {
            Alert(title: Text("GAME COMPLETED"), message: Text("Your Total Score is: \(totalScore)"), dismissButton: .default(Text("Start New Game")) {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
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
            gameFinished = true
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
