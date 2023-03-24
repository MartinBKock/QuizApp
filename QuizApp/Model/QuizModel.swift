//
//  QuizModel.swift
//  QuizApp
//
//  Created by Martin Kock on 22/03/2023.
//

import Foundation

struct TriviaQuestion: Codable,Hashable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]

    enum CodingKeys: String, CodingKey {
        case category, type, difficulty, question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }

}

struct TriviaResult: Codable, Hashable {
    let responseCode: Int
    let results: [TriviaQuestion]

    enum CodingKeys: String, CodingKey, Hashable {
        case responseCode = "response_code"
        case results
    }
}


extension TriviaQuestion {
    var allAnswers: [String] {
        var answers = incorrectAnswers
        answers.append(correctAnswer)
        return answers.sorted()
    }
}

