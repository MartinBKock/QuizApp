//
//  CategoryModel.swift
//  QuizApp
//
//  Created by Martin Kock on 22/03/2023.
//

import Foundation

struct CategoryResponse: Codable, Hashable {
    let triviaCategories: [Category]
    
    enum CodingKeys: String, CodingKey {
        case triviaCategories = "trivia_categories"
    }
}

struct Category: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    
    var categoryID: Int {
        return id
    }


    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
