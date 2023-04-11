//
//  QuestionView.swift
//  QuizApp
//
//  Created by Martin Kock on 22/03/2023.
//

import SwiftUI

struct QuestionView: View {
    @EnvironmentObject var stateController: StateController
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    
    @State private var showBool = false
    @State private var isCorrect = false
    @Binding var path: [TriviaQuestion]
   // @Binding var score: Int
    @AppStorage("score") var score = 0
    @Binding var resume: Bool
    
    var url: URL
    var question: TriviaQuestion
    
    var body: some View {
        ZStack {
            BackgroundView().ignoresSafeArea()
            
            VStack {
                VStack {
                    Text("Question:")
                        .font(.title)
                    Text(question.question.decodeBase64() ?? "Error loading question")
                        .font(.headline)
                    
                    
                    AnswersView(
                        question: question,
                        isCorrect: $isCorrect,
                        showBool: $showBool,
                        score: $score
                    )
                    .frame(width: 300, height: 200)
                    .padding()
                    
                    
                    
                }.multilineTextAlignment(.center)
                
                
                VStack {
                    if showBool {
                        if isCorrect {
                            Text("Correct!")
                                .font(.title)
                                .foregroundColor(.green)
                                .padding()
                        } else {
                            Text("False!")
                                .font(.title)
                                .foregroundColor(.red)
                                .padding()
                        }
                        if stateController.questions.count == 1 {
                            addRectangle("Click here to finish")
                                .frame(width: 300, height: 50)
                            
                                .onTapGesture {
                                    showAlert = true
                                }
                            if path.count == 10 {
                                addRectangle("Continue with 10 more questions?")
                                    .frame(width: 300, height: 50)
                                    .onTapGesture {
                                        stateController.fetchQuestions(from: url)
                                        stateController.write(stateController.questions, filename: "Questions")
                                        showBool = false
                                    }
                            } 
                        } else {
                            addRectangle("Next Question")
                                .frame(width: 300, height: 50)
                            
                                .onTapGesture {
                                    if stateController.questions.count == 1 {
                                        showAlert = true
                                    } else {
                                 
                                        stateController.nextQuestion()
                                        stateController.write(stateController.questions, filename: "Questions")
                                        path.append(stateController.currentQuestion!)
                                        stateController.write(path, filename: "NavigationPath")
                                    }
                                    
                                }
                        }
                        
                    }
                }.frame(height: 200)
                
                
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Quiz Finished"),
                            message: Text("Congratulations! You have finished the quiz with a score of \(score)."),
                            dismissButton: .default(Text("OK")) {
                                stateController.questions.removeAll()
                                stateController.oldQuestions.removeAll()
                                stateController.write(stateController.questions, filename: "Questions")
                                stateController.fetchQuestions(from: url)
                                path.removeAll()
                                stateController.write(path, filename: "NavigationPath")
                                resume.toggle()
                                score = 0
                                
                            }
                        )
                    }
            }
            .background(Color.clear)
        }
    }
    private func addRectangle(_ text: String) -> some View{
        return ZStack {
            Rectangle()
                .foregroundColor(Color.clear)
                .cornerRadius(20)
                .shadow(radius: 3)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 3)
                )
            
            
            VStack {
                Text("\(text)")
                    .foregroundColor(Color.white)
                    .font(.headline)
                    .bold()
                
            }
        }
        
    }
    
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(
            path: .constant([TriviaQuestion(category: "", type: "", difficulty: "", question: "", correctAnswer: "", incorrectAnswers: ["", ""])]),  resume: .constant(false), url: URL(string: "https://www.google.com")!,
            question: TriviaQuestion(
                category: "History".toBase64(),
                type: "multiple".toBase64(),
                difficulty: "easy".toBase64(),
                question: "What was the first country to recognize the United States?".toBase64(),
                correctAnswer: "Morocco".toBase64(),
                incorrectAnswers: ["France".toBase64(), "Spain".toBase64(), "Netherlands".toBase64()]
            )
        )
        .environmentObject(StateController())
    }
}
