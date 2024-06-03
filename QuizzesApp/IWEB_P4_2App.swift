//
//  IWEB_P4_2App.swift
//  IWEB_P4.2
//
//  Created by Eric Ordas Martin on 5/12/23.
//

import SwiftUI

@main
struct IWEB_P4_2App: App {

    @State var quizzesModel = QuizzesModel()
    @State var scoresModel = ScoresModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
             .environment(quizzesModel)
             .environment(scoresModel)
        }
    }
}
