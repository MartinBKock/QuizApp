//  SelectView.swift
//  QuizApp
//
//  Created by Martin Kock on 22/03/2023.
//

import SwiftUI

struct SelectView: View {
    @EnvironmentObject var stateController: StateController
    let difficulty = ["easy", "medium", "hard"]
    
    @State private var selectedCategory: Category = StateController().categories.first ?? Category(id: 9, name: "General knowledge")
    @State private var selectedDif = "easy"
    @State var path = [TriviaQuestion]()
    
    @AppStorage("score") var score = 0
    //@State var score = 0;
    @State var urlTry = "";
    @State var resumeShow = false
    @State var resume = false
    
    var body: some View {
     
        
        
        NavigationStack(path: $path) {
            ZStack {
                BackgroundView()
                VStack(alignment: .leading, spacing: 40) {
                    
                    if (stateController.path.count > 0 && stateController.oldQuestions.count > 0 && resume == false){
                        VStack {
                            Button {
                                resume.toggle()
                                resumeShow.toggle()
                            } label: {
                                Text("Resume?")
                                    .foregroundColor(.white)
                            }

                        }
                    }
                    VStack {
                        HStack {
                            Text("Category:")
                                .dynamicTypeSize(.xxLarge)
                                .foregroundColor(Color.white)
                            
                            if stateController.categories.isEmpty {
                                ProgressView()
                            } else {
                                Picker("Select a Category", selection: $selectedCategory) {
                                    ForEach(stateController.categories, id: \.id) { category in
                                        Text(category.name).tag(category)
                                    }
                                }
                                .tint(.white)
                                .pickerStyle(.menu)
                                .dynamicTypeSize(.xxLarge)
                                .onChange(of: selectedCategory) { _ in
                                    stateController.fetchAllQuestionsOfCategory(from: URL(string: stateController.createUrlForAllQuestionsInCategory(category: selectedCategory))!)
                                    stateController.fetchNumberOfQuestionsForSingleDif(from: URL(string: stateController.createUrlForAllQuestionsInCategory(category: selectedCategory))!, dif: selectedDif)
                                    update()
                                }
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            if stateController.numberOfQuestionsOfCat == 0 {
                                ProgressView()
                            } else {
                                Text("no. of questions: \(stateController.numberOfQuestionsOfCat)")
                                    .foregroundColor(.white)
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    VStack {
                        HStack {
                            Text("Difficulty: ")
                                .dynamicTypeSize(.xxLarge)
                                .foregroundColor(Color.white)
                            
                            Picker("Select a Difficulty", selection: $selectedDif) {
                                ForEach(difficulty, id: \.self) { dif in
                                    Text(dif.capitalized)
                                }
                            }
                            .tint(.white)
                            .dynamicTypeSize(.xxLarge)
                            .onChange(of: selectedDif) { _ in
                                stateController.fetchNumberOfQuestionsForSingleDif(from: URL(string: stateController.createUrlForAllQuestionsInCategory(category: selectedCategory))!, dif: selectedDif)
                                update()
                            }
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            if stateController.numberOfQuestionsInDif == 0 {
                                ProgressView()
                            } else {
                                Text("no. of questions in dif: \(stateController.numberOfQuestionsInDif)")
                                    .foregroundColor(.white)
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    VStack {
                        
                        
                        if stateController.questions.count > 0 && stateController.numberOfQuestionsOfCat > 0 && urlTry != ""{
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Color.clear)
                                    .cornerRadius(20)
                                    .shadow(radius: 3)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white, lineWidth: 3)
                                    )
                                VStack {
                                    NavigationLink("Generate Quiz", value: stateController.questions[0])
                                        .tint(.white)
                                        .dynamicTypeSize(.accessibility1)
                                    
                                }
                            }.frame(width: 250, height: 50)
                            
                            
                        } else {
                            Text("Loading questions...")
                                .foregroundColor(Color.white)
                        }
                    }.navigationDestination(for: TriviaQuestion.self) { _ in
                        QuestionView(path: $path, resume: $resume, url: URL(string: urlTry)!, question: stateController.questions[0])
                        
                            .navigationBarBackButtonHidden(true)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Text("current score: \(score)")
                                }
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Image(systemName: "house")
                                        .onTapGesture {
                                            path.removeAll()
                                            
                                            score = 0
                                            let url = stateController.createURLString(category: selectedCategory, difficulty: selectedDif, numQuestions: 10)
                                            
                                            stateController.fetchQuestions(from: URL(string: url)!)
                                        }
                                }
                            }
                    }.frame(maxWidth: .infinity).offset(x: -20, y: 20)
                }
                .padding(.horizontal)
                .offset(x: 20, y: -125)
                .frame(width: 400)
                .onAppear {
                    update()
                }
                .navigationTitle("")
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Text("QUIZ MASTER")
                                .font(.title).italic().foregroundColor(Color.white)
                        }
                    }
                }
                .ignoresSafeArea()
                .alert(isPresented: $resumeShow) {
                    Alert(
                        title: Text("Resume"),
                        message: Text("You are now resuming."),
                        dismissButton: .default(Text("OK")) {
                            path = stateController.path
                            stateController.questions = stateController.oldQuestions
                        }
                    )
                }
            }
            
            
        }
        
    }
    private func update() {
        
        stateController.fetchAllQuestionsOfCategory(from: URL(string: stateController.createUrlForAllQuestionsInCategory(category: selectedCategory))!)
     
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            var numQuestions: Int
            if stateController.numberOfQuestionsInDif >= 10 {
                numQuestions = 10
            } else {
                numQuestions = stateController.numberOfQuestionsInDif
            }
            let url = stateController.createURLString(category: selectedCategory, difficulty: selectedDif, numQuestions: numQuestions)
            urlTry = url
          
            stateController.fetchQuestions(from: URL(string: url)!)
        }
    }
    
    
}


struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView().environmentObject(StateController())
    }
}
