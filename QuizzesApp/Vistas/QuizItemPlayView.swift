//
//  QuizItemPlay.swift
//  IWEB_P4.2
//
//  Created by c101 DIT UPM on 20/11/23.
//

import SwiftUI


struct QuizItemPlayView: View{
    
    @Environment(QuizzesModel.self) var quizzesModel

    @Environment(ScoresModel.self) var scoresModel

    @Environment(\.verticalSizeClass) var vsc

    var quizItem: QuizItem
    
    @State var answer: String = ""
    
    @State var show_alertCheck = false
    
    @State var checkingResponse = false
    
    @State var errorMsg = "" {
        didSet{
            showErrorMsgAlert = true
        }
    }
    
    @State var showErrorMsgAlert = false
    
    @State var answerIsOK = false
    @State var ac = ""
    
    
    @State private var rotationAngle: Double = 0
    
    
    
    var body: some View{
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.green, .mint]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Text(quizItem.question)
                        .fontWeight(.bold)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .italic()
                    Spacer()
                    estrella
                }
                if vsc == .compact {
                    HStack{
                        VStack{
                            Spacer()
                            pregunta
                                .alert("RESULTADO", isPresented: $show_alertCheck){
                                    
                                }message:{
                                    Text(answerIsOK ? "BIEN HECHO, SIGUE ASÍ" : "MAL, INTÉNTALO DE NUEVO")
                                    
                                }
                                
                            Spacer()
                            Text("Puntos = \(scoresModel.acertadas.count)")
                              .font(.title)
                              .foregroundStyle(.pink)
                        }
                        VStack{
                            adjunto
                            autor
                        }
                    }
                } else{
                    Spacer()
                    pregunta
                        .alert("RESULTADO", isPresented: $show_alertCheck){
                            
                        }message:{
                            Text(answerIsOK ? "BIEN HECHO, SIGUE ASÍ" : "MAL, INTÉNTALO DE NUEVO")
                            
                        }
                    adjunto
                    autor
                    Spacer()
                    Text("Puntos = \(scoresModel.acertadas.count)")
                      .font(.title)
                      .foregroundStyle(.pink)
                }
               
            }}}
    
    private var estrella: some View {
        Button(action: {
            Task {
                do {
                    try await quizzesModel.toggleFavorite(quizItem: quizItem)
                } catch {
                    print("Error: \(error)")
                }
            }
        }) {
            Image(quizItem.favourite ? "yellow_star" : "grey_star")
                .resizable()
                .frame(width: 40, height: 40)
        }
    }

    
    
    private var pregunta: some View{
        VStack{
            TextField("Introduzca la respuesta", text:$answer)
                .fontWeight(.bold)
                .textFieldStyle(.roundedBorder)
                .opacity(0.6)
                .onSubmit {
                    Task{
                        await checkResponse()
                        show_alertCheck = true
                    }
                    withAnimation{
                        checkingResponse = true
                        r = 360 - r
                    }
                    
                }.alert("RESULTADO", isPresented: $show_alertCheck){
                    
                }message:{
                    Text(answerIsOK ? "BIEN HECHO, SIGUE ASÍ" : "MAL, INTÉNTALO DE NUEVO")
                    
                }
            if checkingResponse{
                ProgressView()
            } else{
                Button("Comprobar"){
                    
                    Task{
                        await checkResponse()
                        show_alertCheck = true
                        
                    }
                    withAnimation{
                        checkingResponse = true
                        r = 360 - r
                    }
                    
                }
            }
            
        }
    }
    
    
    @State var scale = 1.0
    @State var r = 0.0
    private var adjunto: some View{
        AsyncImage(url: quizItem.attachment?.url) { phase in
            switch phase {
            case .empty:
                Image(systemName: "network.slash")
                    .foregroundColor(.red)
            case .success(let image):
                image.resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .contentShape(RoundedRectangle(cornerRadius: 10))
                    .frame(maxWidth: 300, maxHeight: 300)
                    .scaleEffect(scale)
            case .failure:
                Image(systemName: "network.slash")
                    .foregroundColor(.green)
            @unknown default:
                Image(systemName: "network.slash")
                    .foregroundColor(.green)
            }
        }
        .rotationEffect(Angle(degrees: r))
        .onTapGesture(count: 2) {
            Task{
                let ac = await Endpoints.seeAnswer2(quizItem: quizItem)
                answer = ac
            }
            withAnimation{
                scale = 1.5 - scale
                r = 720 - r
            } completion: {
                withAnimation{
                    scale = 1.5 - scale
                    r = 720 - r
                }
            }
        }
        
    }
    
    
    private var autor: some View{
        HStack{
            AsyncImage(url: quizItem.author?.photo?.url )  {
            phase in
               switch phase {
               case .empty:
                   Image(systemName: "network.slash")
                       .foregroundColor(.red)
               case .success(let image):
                   image.resizable()
                       .scaledToFit()
                       .scaledToFill()
                       .clipShape(Circle())
                       .contentShape(RoundedRectangle(cornerRadius: 10))
                       .frame(maxWidth: 50, maxHeight: 50)
                       .overlay{
                           Circle().stroke(Color.red, lineWidth: 2)
                       }
               case .failure:
                   Image(systemName: "network.slash")
                       .foregroundColor(.green)
               @unknown default:
                   Image(systemName: "network.slash")
                       .foregroundColor(.green)
               }
                
           }
            .contextMenu {
               Button(action: {
                   Task{
                       let ac = await Endpoints.seeAnswer2(quizItem: quizItem)
                       answer = ac
                   }

               }) {
                   Text("Ver Respuesta")
                   Image(systemName: "eye")
               }

               Button(action: {
                   
                   scoresModel.cleanup()
                   print("Scores limpiados")
               }) {
                   Text("Limpiar")
                   Image(systemName: "trash")
               }
               
                Button(action: { Task{
                    let ac = await Endpoints.seeAnswer2(quizItem: quizItem)
                    answer = String(ac.first ?? "?")
                }
               }) {
                   Text("Pista")
                   Image(systemName: "forward.fill")
               }
               
                              
               Button(action:{
                   scoresModel.trampas()
                   print("Tramposo")
               }){
                   Text("Trampas")
                   Image(systemName: "shield.lefthalf.filled.trianglebadge.exclamationmark")
               }
           }
           
            Text(quizItem.author?.profileName ?? "Anónimo")
                .font(.footnote)
                
            
        }.navigationTitle("LET'S GO PLAY")
        
    }
    func checkResponse() async{
        do{
            checkingResponse = true
            answerIsOK = try await quizzesModel.check(quizItem: quizItem, answer: answer)
            if answerIsOK == true{
                scoresModel.add(quizItem: quizItem)
            }
            checkingResponse = false
            
        } catch{
            errorMsg = error.localizedDescription
        }
    }
    
  //  func respuesta() async{
    //    do{
    //        ac = try await quizzesModel.getAnswer(quizItem: quizItem)
      //      print("el valor de ac es: \(ac)")
    //    } catch{
   //         errorMsg = error.localizedDescription
   //     }
  //  }
    
    
}



    
  //  #Preview{
  //      var qm = QuizzesModel()
  //      qm.download()

    //    var sm = ScoresModel()
        
    //    return NavigationStack{
    //       QuizItemPlayView(quizItem: qm.quizzes[0])
    //          .environment(sm)
    //    }}
    

