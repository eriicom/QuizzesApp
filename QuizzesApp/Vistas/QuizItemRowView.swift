	//
//  QuizItemRow.swift
//  IWEB_P4.2
//
//  Created by c101 DIT UPM on 20/11/23.
//

import SwiftUI

struct QuizItemRowView: View{
    var quizItem: QuizItem
    var body: some View{
        
        
            VStack{
                HStack{
                foto
                    Spacer()
                pregunta
                    Spacer()	
                favorito
                }
                autores
            }
            
            }
            
    
    
    private var foto: some View{
        AsyncImage(url: quizItem.attachment?.url) { phase in
            switch phase {
            case .empty:
                Image(systemName: "network.slash")
                    .foregroundColor(.green)
            case .success(let image):
                image.resizable()
                    .scaledToFit()
                    .scaledToFill()
                    .clipShape(Circle())
                    .contentShape(Circle())
                    .frame(width: 50, height: 50)
            case .failure:
                Image(systemName: "network.slash")
                    .foregroundColor(.green)
            @unknown default:
                Image(systemName: "network.slash")
                    .foregroundColor(.green)
            }
        }
    }
       // AsyncImage(url: quizItem.attachment?.url)
          //  .frame(width:40, height:40)
            //.clipShape(Circle())
            //.scaledToFill()
            //.scaledToFit()
            //.overlay{
              //  Circle().stroke(Color.green, lineWidth: 2)
            //}
            //.shadow(color: .green, radius: 6, x:0.0, y:0.0)    }
    
    private var pregunta: some View{
        
            Text(quizItem.question)
                .font(.body)
                .lineLimit(3) //poner limitacion de la longitud de la pregunta
        
    }
    
    private var favorito: some View{
        HStack{
            
            Image(quizItem.favourite ? "yellow_star" : "grey_star")
                .resizable()
                .frame(width:30, height:30)
        }
            
        
    }
    
    private var autores: some View{
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
                       .clipShape(Circle())
                       .contentShape(RoundedRectangle(cornerRadius: 10))
                       .frame(maxWidth: 30, maxHeight: 30)
               case .failure:
                   Image(systemName: "network.slash")
                       .foregroundColor(.green)
               @unknown default:
                   Image(systemName: "network.slash")
                       .foregroundColor(.green)
               }
           }
            Text(quizItem.author?.profileName ?? "Anónimo" )
                .font(.footnote)
            Spacer()
        }
    }
    
    
    
}

