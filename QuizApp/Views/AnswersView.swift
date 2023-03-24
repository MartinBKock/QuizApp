//
//  AnswersView.swift
//  QuizApp
//
//  Created by Martin Kock on 22/03/2023.
//

import SwiftUI

struct AnswersView: View {
    @EnvironmentObject var stateController: StateController
    var question: TriviaQuestion
    @Binding var isCorrect: Bool
    @Binding var showBool: Bool
    @Binding var score: Int
    @State private var hasBeenTapped = false
    
    
    var body: some View {
        VStack {
            ForEach(question.allAnswers, id: \.self) { a in
                answerBox(answer: a)
            }
        }
    }
    
    private func ceilToEven(_ value: Int) -> Int {
        return max(value % 2 == 0 ? value : value + 1, 2)
    }
    
    
    private func answerBox(answer: String) -> some View {
        return ZStack {
           
            Rectangle()
                .foregroundColor(Color.white)
                .cornerRadius(8)
                .shadow(radius: 3)
                .onTapGesture {
                    if !showBool {
                        hasBeenTapped = false
                    }
                    if !hasBeenTapped { 
                        hasBeenTapped = true
                        if stateController.checkAnswer(answer, question) {
                            showBool = true
                            isCorrect = true
                            score += 1
                        } else {
                            showBool = true
                            isCorrect = false
                        }
                    }
                }
            
            Text(answer.decodeBase64() ?? "Fejl i svar")
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .padding(8)
                .foregroundColor(.black) 
            
            
        }
    }
}

struct AnswersView_Previews: PreviewProvider {
    static var previews: some View {
        AnswersView(question: TriviaQuestion(category: "blah".toBase64(), type: "multiple".toBase64(), difficulty: "easy".toBase64(), question: "Hello".toBase64(), correctAnswer: "svarmulighed 3".toBase64(), incorrectAnswers: ["svarmulighed 1".toBase64(), "svarmulighed 2".toBase64(), "svarmulighed 4".toBase64()]), isCorrect: .constant(false), showBool: .constant(false), score: .constant(0)).environmentObject(StateController())
    }
}
