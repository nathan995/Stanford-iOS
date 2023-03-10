//
//  Cardify.swift
//  Memorize
//
//  Created by Nathan Getachew on 1/22/23.
//

import SwiftUI

struct Cardify : AnimatableModifier {
    
    init(isFaceUp:Bool){
        rotation = isFaceUp ? 0 : 180
    }
    
    var rotation : Double
    
    var animatableData : Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    func body(content : Content) -> some View  {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
               
            if rotation < 90 {
                shape
                shape.foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            } else {
                shape
            }
            content.opacity(rotation < 90 ? 1 : 0)
            
        }.rotation3DEffect(Angle.degrees(rotation), axis: (x:0, y:1, z: 0))
    }
    
    private struct DrawingConstants {
        static let cornerRadius : CGFloat = 15
        static let lineWidth : CGFloat  = 3
        static let fontScale = 0.5
        
        
    }
    
}

extension View {
    func cardify (isFaceUp : Bool) -> some View{
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
