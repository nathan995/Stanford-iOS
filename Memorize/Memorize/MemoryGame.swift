//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Nathan Getachew on 1/20/23.
//

import Foundation

struct MemoryGame<CardContent> where CardContent : Equatable {
    private(set) var cards : Array<Card>
    
    private var indexOfFaceUpCard : Int?
    
    mutating func choose(_ card : Card){
        if let chosenIndex =  cards.firstIndex(where: {$0.id == card.id}), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched  {
            if let potentialMatchIndex = indexOfFaceUpCard {
                if cards[potentialMatchIndex].content == cards[chosenIndex].content{
                    cards[potentialMatchIndex].isMatched = true
                    cards[chosenIndex].isMatched = true
                }
                indexOfFaceUpCard = nil
                
            }else {
                for index in cards.indices{
                    if cards[index].isFaceUp{
                        cards[index].isFaceUp.toggle()
                    }
                }
                indexOfFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
  
    init(numberOfPairsOfCards:Int,createCardContent:(Int)->CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards{
            let content = createCardContent(pairIndex)
            cards.append(Card(content:content,id: pairIndex * 2))
            cards.append(Card( content: content,id: pairIndex * 2 + 1  ))
        }
        cards.shuffle()
    }
    
    struct Card : Identifiable {
        
        var isFaceUp : Bool = false
        var isMatched : Bool = false
        var content : CardContent
        var id : Int
        
    }
}
