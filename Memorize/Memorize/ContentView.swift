//
//  ContentView.swift
//  Memorize
//
//  Created by Nathan Getachew on 1/19/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel : EmojiMemoryGame
    var body: some View {
        
        ScrollView{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))] ){
                ForEach(viewModel.cards ){ card in
                    CardView( card:card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
            }
        }
        
        .padding(.horizontal)
        .foregroundColor(.blue)
        
    }
    //
}



struct CardView : View {
    let card : MemoryGame<String>.Card
    var body : some View {
        ZStack {
            if card.isMatched{
                RoundedRectangle(cornerRadius: 20).foregroundColor(.clear)
            } else {
                
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: 20)
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(lineWidth: 3)
                    Text(card.content)
                        .font(.largeTitle)
                } else {
                    RoundedRectangle(cornerRadius: 20)
                }
            }
        }
    }
}













struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        let game = EmojiMemoryGame()
        ContentView(viewModel: game)
    }
    
}
