//
//  BackgroundView.swift
//  QuizApp
//
//  Created by Martin Kock on 22/03/2023.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Gradient(colors: [.teal, Color(uiColor: .darkText)]))
                .ignoresSafeArea()
        }
    }
}

struct Background_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
