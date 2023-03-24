//
//  ContentView.swift
//  QuizApp
//
//  Created by Martin Kock on 22/03/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var stateController: StateController
    var body: some View {
            ZStack {
                BackgroundView()
                VStack {
                    
                    if (stateController.categories.count == 0) {
                                Text("loading up...")
                                   .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                           } else {
                               SelectView()
                           }
                }.ignoresSafeArea()
                
                .padding()
            }.ignoresSafeArea(.all)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(StateController())
    }
}
