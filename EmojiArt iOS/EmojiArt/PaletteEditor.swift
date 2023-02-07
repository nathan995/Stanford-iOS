//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by Nathan Getachew on 1/28/23.
//

import SwiftUI

struct PaletteEditor: View {
    @Binding  var palette : Palette
    var body: some View {
        Form {
            nameSection
            addEmojisSection
            removEmojiSection
        }.frame(minWidth: 300,minHeight: 350)
            .navigationTitle("Edit \(palette.name)")
//            .navigationBarTitleDisplayMode(.inline)
    }
    var nameSection: some View {
        Section (header: Text( "Name")) {
            TextField ( "", text: $palette.name)
        }
    }
    
    @State private var emojisToAdd = ""
    
    var addEmojisSection: some View {
        Section (header: Text( "Add Emojis")) {
            TextField ( "", text: $emojisToAdd).onChange(of: emojisToAdd){ emojis in
                addEmojis(emojis: emojis)
                
            }
        }
    }
    
    func addEmojis(emojis : String ) {
        withAnimation{
            palette.emojis = (emojis + palette.emojis).filter{ $0.isEmoji }
        }
    }
    
    var removEmojiSection: some View {
        Section (header: Text ("Remove Emoji" )) {
            let emojis = palette.emojis.map { String($0) }
            LazyVGrid (columns: [GridItem(.adaptive (minimum: 40))]) {
                ForEach (emojis, id: \.self) { emoji in
                    Text (emoji)
                        .onTapGesture {
                            withAnimation {
                                palette.emojis.removeAll (where: { String($0) == emoji })
                            }
                        }
                }
                . font (.system(size: 40))
            }
        }
    }
    
    
}

struct PaletteEditor_Previews: PreviewProvider {
    static var previews: some View {
        
        PaletteEditor(palette:  .constant(PaletteStore(named:"Preview").palette(at: 2)))
    }
}
