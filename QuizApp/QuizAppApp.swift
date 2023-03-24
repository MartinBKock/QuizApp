//
//  QuizAppApp.swift
//  QuizApp
//
//  Created by Martin Kock on 22/03/2023.
//

import SwiftUI

@main
struct QuizAppApp: App {
    @StateObject var stateController = StateController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(stateController)
                
        }
    }
}
