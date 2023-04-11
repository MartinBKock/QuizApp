//
//  StateController.swift
//  QuizApp
//
//  Created by Martin Kock on 22/03/2023.
//

import SwiftUI

class StateController: ObservableObject {
    @Published var questions = [TriviaQuestion]()
    @Published var oldQuestions = [TriviaQuestion]()
    @Published var categories = [Category]()
    @Published var currentQuestion: TriviaQuestion?
    @Published var path = [TriviaQuestion]()
    @Published var numberOfQuestionsOfCat: Int = 0
    @Published var numberOfQuestionsInDif: Int = 0
    
    
    
    init() {
        guard let categoryUrl = URL(string: "https://opentdb.com/api_category.php") else {return}
        fetchCategories(from: categoryUrl)
        
        fetchQuestions(from: URL(string: "https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&encode=base64")!)
        fetchNumberOfQuestionsForSingleDif(from: URL(string: createUrlForAllQuestionsInCategory(category: Category(id: 9, name: "General Knowledge")))!, dif: "easy")
        
        if read(filename: "NavigationPath").count > 0 {
            path = read(filename: "NavigationPath")
            print("path: \(path.count)")
        }
        
        if read(filename: "Questions").count > 0 {
            oldQuestions = read(filename: "Questions")
            print("Questions: \(oldQuestions.count)")
        }
    
        
        
    }
    
    func fetchQuestions(from url: URL) {
        Task {
            guard let rawQuizData = await NetworkService.getData(from: url) else {return}
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(TriviaResult.self, from: rawQuizData)
                DispatchQueue.main.async {
                    self.questions = result.results
                }
            } catch {
                fatalError("YOU SUCK at converting from JSON!")
            }
        }
    }
    
    func setQuestions(from url: URL) {
        if categories.isEmpty {
            fetchCategories(from: url)
        } else {
            categories.removeAll()
            fetchCategories(from: url)
        }
    }
    
    func fetchCategories(from url: URL) {
        Task {
            guard let rawCategoriesData = await NetworkService.getData(from: url) else {return}
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(CategoryResponse.self, from: rawCategoriesData)
                DispatchQueue.main.async {
                    self.categories = result.triviaCategories
                }
            } catch {
                fatalError("Failed to decode JSON data: \(error)")
            }
        }
    }
    func fetchAllQuestionsOfCategory(from url: URL) {
        Task {
            guard let rawCategoryData = await NetworkService.getData(from: url) else { return }
            let decoder = JSONDecoder()
            do {
                let categoryInfo = try decoder.decode(CategoryInfo.self, from: rawCategoryData)
                DispatchQueue.main.async {
                    self.numberOfQuestionsOfCat = categoryInfo.questionCount.totalQuestionCount
                }
            } catch {
                fatalError("Failed to decode category data from JSON: \(error)")
            }
        }
    }
    func fetchNumberOfQuestionsForSingleDif(from url: URL, dif: String) {
        numberOfQuestionsInDif = 0
        Task {
            guard let rawCategoryData = await NetworkService.getData(from: url) else { return }
            let decoder = JSONDecoder()
            do {
                let categoryInfo = try decoder.decode(CategoryInfo.self, from: rawCategoryData)
                DispatchQueue.main.async {
                    if dif == "easy" {
                        self.numberOfQuestionsInDif = categoryInfo.questionCount.totalEasyQuestionCount
                    } else if dif == "medium"{
                        self.numberOfQuestionsInDif = categoryInfo.questionCount.totalMediumQuestionCount
                    } else {
                        self.numberOfQuestionsInDif = categoryInfo.questionCount.totalHardQuestionCount
                    }
                }
            } catch {
                fatalError("Failed to decode category data from JSON: \(error)")
            }
        }
    }
    
    
    func createURLString(category: Category, difficulty: String, numQuestions: Int) -> String {
        let baseURL = "https://opentdb.com/api.php?"
        let categoryParam = "category=\(category.id)"
        let difficultyParam = "difficulty=\(difficulty)"
        let numQuestionsParam = "amount=\(numQuestions)"
        let encode = "encode=base64"
        
        return "\(baseURL)\(categoryParam)&\(difficultyParam)&\(numQuestionsParam)&\(encode)"
    }
    func createUrlForAllQuestionsInCategory(category: Category) -> String{
        let baseUrl = "https://opentdb.com/api_count.php?category="
        let catId = category.id
        return "\(baseUrl)\(catId)"
    }
    
    func checkAnswer(_ answer: String, _ question: TriviaQuestion) -> Bool {
        if answer == question.correctAnswer {
            return true
        } else {
            return false
        }
    }
    
    func nextQuestion() {
        guard !questions.isEmpty else {
            currentQuestion = nil
            return
        }
        if questions.count > 1 {
            let nextQuestion = questions.removeFirst()
            currentQuestion = nextQuestion
        }
    }
    
    func write<T: Encodable>(_ object: T, filename: String) {
        let homeFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let path = homeFolder?.appendingPathComponent("\(filename).json")
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: path!)
        } catch {
            print("Could not write file \(path!): \(error)")
        }
    }
    
    func read(filename: String) -> [TriviaQuestion] {
        let homeFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let path = homeFolder?.appendingPathComponent("\(filename).json")
        guard let data = try? Data(contentsOf: path!), !data.isEmpty else {
            return []
        }
        let decoder = JSONDecoder()
        return try! decoder.decode([TriviaQuestion].self, from: data)
    }



  
    
}

extension String {
    func decodeBase64() -> String? {
        guard let decodedData = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: decodedData, encoding: .utf8)
    }
    
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}







