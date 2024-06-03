//
//  ScoresModel.swift
//  IWEB_P4.2
//
//  Created by c101 DIT UPM on 22/11/23.
//

import Foundation

@Observable class ScoresModel {
    var acertadas: Set<Int> = []
    var record: Set<Int> = []
    
    init() {
       let a = UserDefaults.standard.object(forKey: "record") as? [Int] ?? []
        record = Set(a)
    }
 
    
    func check(quizItem: QuizItem, answer: String){
        
     //   if answer =+-= quizItem.answer{
   //         acertadas.insert(quizItem.id)
  //      }
    }
    
    func add(quizItem: QuizItem){
        acertadas.insert(quizItem.id)
        record.insert(quizItem.id)
        
        UserDefaults.standard.set(Array(record), forKey: "record")
        UserDefaults.standard.synchronize()
        
    }
    
    func pendiente(_ quizItem: QuizItem)-> Bool{
        !acertadas.contains(quizItem.id)
    }
    
    func checkResponse() async -> Bool{
        return true
    }
    
    func cleanup() {
        acertadas = []
    }
    
    func trampas() {
        let trampas = (0..<10).map { _ in Int.random(in: 500...1000) }
        acertadas.formUnion(trampas)
    }
        
}
