//
//  AnswerButton.swift
//  QuizApp
//
//  Created by Martin Kock on 22/03/2023.
//

import SwiftUI

struct AnswerButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(configuration.isPressed ? Color.green : Color.red)
            .cornerRadius(8)
            .shadow(radius: 3)
    }
}

