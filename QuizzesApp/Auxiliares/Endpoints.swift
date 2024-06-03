    //
    //  Endpoints.swift
    //  IWEB_P4.2
    //
    //  Created by Eric Ordas Martin on 7/12/23.
    //

    import Foundation


    let urlBase = "https://quiz.dit.upm.es"

    let token = "cd1b9d1de97baf7114bf"

    struct Endpoints {
        
        static func random10() -> URL? {
            let path = "/api/quizzes/random10"
            let str = "\(urlBase)\(path)?token=\(token)"
            return URL(string: str)
        }
        
        static func checkAnswer(quizItem: QuizItem, answer: String) -> URL? {
            let path = "/api/quizzes/\(quizItem.id)/check"
            guard let escapedAnswer = answer.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return nil}
            let str = "\(urlBase)\(path)?answer=\(escapedAnswer)&token=\(token)"
            return URL(string: str)
        }
        
        
        static func seeAnswer2(quizItem: QuizItem) async -> String {
            do {
                let path = "/api/quizzes/\(quizItem.id)/answer"
                let urlString = "\(urlBase)\(path)?token=\(token)"

                guard let url = URL(string: urlString) else {
                    return "No answer"
                }

                let (data, _) = try await URLSession.shared.data(from: url)
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                if let answer = json?["answer"] as? String {
                    return answer
                } else {
                    return "No answer"
                }
            } catch {
                return "No answer"
            }
        }

        
        static func verRespuesta(quizItem: QuizItem)-> URL?{
            let path = "/api/quizzes/\(quizItem.id)/answer"
             let urlString = "\(urlBase)\(path)?token=\(token)"
            return URL(string: urlString)
        }
        

        static func toggleFav(quizItem: QuizItem)->URL?{
            let path = "/api/users/tokenOwner/favourites"
            let str = "\(urlBase)\(path)/\(quizItem.id)?token=\(token)"
            return URL(string: str)
        }
    }
