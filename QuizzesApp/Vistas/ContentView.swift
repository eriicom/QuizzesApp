    //
    //  ContentView.swift
    //  IWEB_P4.2
    //
    //  Created by c101 DIT UPM on 20/11/23.
    //

    import SwiftUI

struct ContentView: View {
    
    
    @Environment(QuizzesModel.self) var quizzesModel
    @Environment(ScoresModel.self) var scoresModel
    
    @State var errorMsg = "" {
        didSet {
            showErrorMsgAlert = true
        }
    }
    
    @State var showErrorMsgAlert = false
    @State var todosQuizzes = true
    @State var showPuntosView = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.green, .mint]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack{
                    contenido
                    Toggle("Mostrar Todos", isOn: $todosQuizzes)
                        .padding()
                        .toggleStyle(CustomToggleStyle())
                }
            }}}
    private var contenido: some View{
        
        List {
            ForEach(Array(zip(quizzesModel.quizzes.indices, quizzesModel.quizzes)), id: \.0) { index, quizItem in
                            if (todosQuizzes || scoresModel.pendiente(quizItem)) {
                                Section(header: Text("QUIZ \(index + 1)")) {
                                    NavigationLink {
                                        QuizItemPlayView(quizItem: quizItem)
                                    } label: {
                                        QuizItemRowView(quizItem: quizItem)
                        }
                    }
                }
            }}.scrollContentBackground(.hidden)
            .navigationTitle("THE QUIZZ GAME")
            .navigationBarItems(
                leading: NavigationLink(destination: PuntosView(), isActive: $showPuntosView) {
                                Text("RECORD = \(scoresModel.record.count)")
                            },
                trailing: Button(action: {
                    Task {
                        do {
                            try await quizzesModel.download()
                            scoresModel.cleanup()
                        } catch {
                            errorMsg = error.localizedDescription
                        }
                    }
                }, label: {
                    Label("Refrescar", systemImage: "arrow.counterclockwise")
                })
            )
            .alert("Error", isPresented: $showErrorMsgAlert) {
            } message: {
                Text(errorMsg)
            }
            .task {
                do {
                    guard quizzesModel.quizzes.count == 0 else { return }
                    try await quizzesModel.download()
                } catch {
                    errorMsg = error.localizedDescription
                }
            }
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Toggle(configuration)
            .toggleStyle(SwitchToggleStyle(tint: .blue)) // Establecer el color del Toggle
    }
}
            

        

    #Preview{
        ContentView()
    }

