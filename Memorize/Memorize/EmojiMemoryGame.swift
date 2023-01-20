//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Nathan Getachew on 1/20/23.
//

import SwiftUI

class EmojiMemoryGame : ObservableObject{
    
    static let emojis = ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", " 🚚", "🚛", "🚜", "🦯", "🦽", "🦼", "🛴", "🚲", "🛵", "🏍", "🛺", "🚨", "🚔"]
    
    static func createMemoryGame ()-> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 8){
            pairIndex in emojis[pairIndex]
        }
    }
    
    
    @Published private var model = createMemoryGame()
    
    var cards : Array<MemoryGame<String>.Card>{
        return model.cards
    }
   
    // MARK: - Intent(s)
    
    func choose(_ card:MemoryGame<String>.Card){
        print("bye")
        model.choose(card)
    }
    
    
}
