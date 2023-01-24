//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Nathan Getachew on 1/20/23.
//

import SwiftUI

class EmojiMemoryGame : ObservableObject{
   
    
    
    private static let emojis = ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", " 🚚", "🚛", "🚜", "🦯", "🦽", "🦼", "🛴", "🚲", "🛵", "🏍", "🛺", "🚨", "🚔"]
    
    private static func createMemoryGame ()-> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4){
            pairIndex in emojis[pairIndex]
        }
    }
    
    
    @Published private var model = createMemoryGame()
    
    var cards : Array<MemoryGame<String>.Card>{
        return model.cards
    }
   
    // MARK: - Intent(s)
    
    func choose(_ card:MemoryGame<String>.Card){
        model.choose(card)
    }
    
    func shuffle(){
        model.shuffle()
    }
    func restart(){
        model = EmojiMemoryGame.createMemoryGame()
    }
    
    
}
