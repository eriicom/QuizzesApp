    //
    //  QuizzesModel.swift
    //  P4.1 Quiz
    //
    //  Created by Santiago Pavón Gómez on 11/9/23.
    //

    import Foundation

@Observable class QuizzesModel {
    
    // Los datos
    private(set) var quizzes = [QuizItem]()
    
    
    func download() async throws{
        guard let url = Endpoints.random10() else{
            throw "Fallos piratas"
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{
            throw "No bebes no quizzes"
        }
        print("Datos recibidos: \(String(data: data, encoding: .utf8) ?? "No se pudo convertir a cadena")")
        guard let q = try? JSONDecoder().decode([QuizItem].self, from: data) else{
            throw "Recibidos datos corruptos"
        }
        self.quizzes = []
        self.quizzes = q
        print("Quizzes creados")
        
    }
    
    func check(quizItem: QuizItem, answer: String) async throws -> Bool{
        guard let url = Endpoints.checkAnswer(quizItem: quizItem, answer: answer) else{
            throw "fallas respuesta"
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{
            throw "fallito de servidor"
        }
        
        guard let res = try? JSONDecoder().decode(CheckResponseItem.self, from: data) else{
            throw "datos corruptos"
        }
        
        return res.result
        
    }
    
    func getAnswer(quizItem: QuizItem) async throws -> String {
        guard let url = Endpoints.verRespuesta(quizItem: quizItem) else{
            throw "fallas respuesta"
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{
            throw "fallito de servidor"
        }
        
        guard let res = try? JSONDecoder().decode(AnswerItem.self, from: data) else{
            throw "datos corruptos"
        }
        
        return res.answer
        
    }
    
   
    
    func toggleFavorite(quizItem: QuizItem) async throws { //4.2 OPCIONAL 1

        guard let url = Endpoints.toggleFav(quizItem: quizItem) else {
                    throw "No puedo comprobar la respuesta"
                }

                var request = URLRequest(url: url)

                request.httpMethod = quizItem.favourite ? "DELETE" : "PUT"

                let (data, response) = try await URLSession.shared.data(for: request)  //peticion al servidor

                print("Sale la Url: \(request)")
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    throw "No funciona"
                }

          guard let res = try? JSONDecoder().decode(FavouriteStatusItem.self, from: data)  else {
                    throw "Error: recibidos datos corruptos."
                }

              guard let index = (quizzes.firstIndex { qi in //buscamos en el array la posicion donde está
            
                qi.id == quizItem.id})

               else {

                    throw "Error 3"
              }

              quizzes[index].favourite = res.favourite

        }}


    

    extension String: LocalizedError{
        public var errorDescription : String? {
            return self
        }
    }
