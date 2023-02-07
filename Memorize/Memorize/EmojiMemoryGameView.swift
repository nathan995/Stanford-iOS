//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Nathan Getachew on 1/19/23.
//

import SwiftUI


struct EmojiMemoryGameView: View {
    
    typealias Card = MemoryGame<String>.Card
    @ObservedObject var game : EmojiMemoryGame
    @Namespace private var dealingNamespace
    @State private var dealt = Set<Int>()
    
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                gameBody
                
                HStack(){
                    shuffleButton
                    Spacer()
                    restartButton
                }
                
            }
            deckBody
            
        }.padding()
            .foregroundColor(.blue)
    }
    
    
  
    
    
    
    private func deal(_ card: Card){
        dealt.insert(card.id)
    }
    
    
    
    private func isUndealt(_ card: Card)->Bool{
        !dealt.contains(card.id)
    }
    
    
    
    private func dealAnimation (for card: Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double (index) * (CardConstants.totalDealDuration / Double (game.cards.count))/2
        }
        return Animation.easeInOut (duration: CardConstants.dealDuration).delay (delay)
    }
    
    
    
    private func zIndex(of card:Card)->Double{
        -Double(game.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    
    
    var gameBody : some View {
        AspectVGrid( items:game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) || ( card.isMatched && !card.isFaceUp ){
                Color.clear
            } else {
                CardView( card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of:card))
                    .onTapGesture {
                        withAnimation(){
                            game.choose(card)
                        }
                    }
            }
        }
    }
    
    
    var deckBody : some View {
        ZStack{
            ForEach(game.cards.filter(isUndealt)){ card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)){
                    deal(card)
                }
            }
        }
        .frame(width: CardConstants.undealtwidth,height: CardConstants.undealtHeight)
        
        
    }
    
    var shuffleButton : some View {
        Button ("Shuffle"){
            withAnimation{
                game.shuffle()
            }
        }.font(.largeTitle)
    }
    
    var restartButton : some View {
        Button("Restart"){
            withAnimation{
                dealt = []
                game.restart()
            }
        }.font(.largeTitle)
    }
    
    private struct CardConstants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtwidth = undealtHeight * aspectRatio
    }
}



struct CardView : View {
    private let card : MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    @State var animatedBonusRemaining : Double = 0
    
    var body : some View {
        GeometryReader{ geometry in
            ZStack {
                Group{
                    if card.isConsumingBonusTime {
                        Pie( startAngle: Angle(degrees: -90),
                             endAngle: Angle(degrees:  (1-animatedBonusRemaining)*360-90))
                        .onAppear{
                            animatedBonusRemaining = card.bonusRemaining
                            withAnimation(.linear(duration: card.bonusTimeRemaining)){
                                animatedBonusRemaining = 0
                            }
                        }
                    } else {
                        Pie( startAngle: Angle(degrees: -90),
                             endAngle: Angle(degrees:  (1-card.bonusRemaining)*360-90))
                    }
                    
                }
                
                .padding(8)
                .opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 :0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits : geometry.size))
            }.cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(thatFits size : CGSize )-> CGFloat {
        min(size.width,size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    
    
    
    private struct DrawingConstants {
        static let fontScale = 0.5
        static let fontSize : CGFloat = 32
    }
    
}











//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let game = EmojiMemoryGame()
//        EmojiMemoryGameView(game: game)
//    }
//
//}
