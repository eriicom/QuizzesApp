//
//  Puntos y record.swift
//  IWEB_P4.2
//
//  Created by Eric Ordas Martin on 14/12/23.
//

import SwiftUI

struct PuntosView: View {
    
    @Environment(QuizzesModel.self) var quizzesModel

    @Environment(ScoresModel.self) var scoresModel
    
    var body: some View{
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.green, .mint]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            VStack{
                Text("RECORD = \(scoresModel.record.count)")
                Text("Puntos actuales = \(scoresModel.acertadas.count)")
                Spacer()
                Text("Actualmente eres: \(puntuacionrango)")
                Button(action: {
                    checkRango()
                }){
                    Text("Toca aquí para saber tu rango")
                }
                Spacer()
                Text("RANGOS:")
                Text("💎Diamante: 100")
                Text("💍Platino: 75")
                Text("🏆Oro: 50")
                Text("🪙Plata: 25")
                Text("🥉Bronce: 5")
                Spacer()
                Spacer()
                
            }
            
            
        }}
    
    
    @State var puntuacionrango = " "
    
    func checkRango() {
        let count = scoresModel.record.count
        
        if count >= 5 && count < 25 {
            puntuacionrango = "🥉BRONCE"
        } else if count >= 25 && count < 50 {
            puntuacionrango = "🪙PLATA"
        } else if count >= 50 && count < 75 {
            puntuacionrango = "🏆ORO"
        } else if count >= 75 && count < 100 {
            puntuacionrango = "💍PLATINO"
        } else if count >= 100 {
            puntuacionrango = "💎DIAMANTE"
        } else if count <= 5 {
            puntuacionrango = "SIN RANGO AÚN, NOOB"
        }
    }
    
}
    



