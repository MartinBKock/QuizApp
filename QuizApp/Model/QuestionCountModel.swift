//
//  QuestionCountModel.swift
//  QuizApp
//
//  Created by Martin Kock on 22/03/2023.
//

import Foundation

struct CategoryInfo: Codable {
    let categoryId: Int
    let questionCount: QuestionCount
    
    enum CodingKeys: String, CodingKey {
        case categoryId = "category_id"
        case questionCount = "category_question_count"
    }
}

struct QuestionCount: Codable {
    let totalQuestionCount: Int
    let totalEasyQuestionCount: Int
    let totalMediumQuestionCount: Int
    let totalHardQuestionCount: Int
    
    enum CodingKeys:String, CodingKey {
        case totalQuestionCount = "total_question_count"
        case totalEasyQuestionCount = "total_easy_question_count"
        case totalMediumQuestionCount = "total_medium_question_count"
        case totalHardQuestionCount = "total_hard_question_count"
    }
    
}
