//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Nathan Getachew on 1/28/23.
//

import SwiftUI

struct PaletteChoser : View {
    var emojiFontSize: CGFloat = 40
    var emojiFont: Font { .system(size: emojiFontSize)  }
    
    @EnvironmentObject var store : PaletteStore
    
    @SceneStorage("PaletteChooser.chosenPaletteIndex") private var chosenPaletteIndex = 0
    
    var body: some View {
        let palette = store.palette(at: chosenPaletteIndex)
        HStack{
            paletteControlButton
            body(for: palette)
        }.clipped()
    }
    
    var gotoMenu : some View {
        Menu {
            ForEach(store.palettes){ palette in
                AnimatedActionButton (title: palette.name){
                    if let index = store.palettes.index(matching: palette){
                        chosenPaletteIndex = index 
                    }
                }
            }
        } label: {
            Label("Go To", systemImage: "text.insert")
        }
    }
    
    @ViewBuilder
    var contextMenu : some View {
        AnimatedActionButton(title: "Edit",systemImage: "pencil"){
            paletteToEdit = store.palette(at: chosenPaletteIndex)
        }
        AnimatedActionButton(title: "New",systemImage: "plus"){
            store.insertPalette(named: "New",emojis: "",at: chosenPaletteIndex)
            paletteToEdit = store.palette(at: chosenPaletteIndex)
        }
        AnimatedActionButton(title: "Delete",systemImage: "minus.circle"){
            chosenPaletteIndex =  store.removePalette(at: chosenPaletteIndex)
        }
        #if os(iOS)
        AnimatedActionButton(title: "Manager",systemImage: "slider.vertical.3"){
            managing = true
        }
        #endif
        gotoMenu
    }
    
    var paletteControlButton : some View {
        Button {
            withAnimation{
                chosenPaletteIndex = ( chosenPaletteIndex + 1 ) % store.palettes.count
            }
        } label: {
            Image(systemName: "paintpalette")
        }
        .font(emojiFont)
        .paletteControlButtonStyle()
        .contextMenu{
            contextMenu
        }
    }
    
    func body ( for palette : Palette) -> some View {
        HStack {
            Text(palette.name)
            ScrollingEmojisView(emojis:palette.emojis)
                .font(emojiFont)
        }
        .id(palette.id)
        .transition(rollTransition)
        .popover(item : $paletteToEdit,arrowEdge: .bottom ){ palette in
            PaletteEditor(palette: $store.palettes[palette])
                .popoverPadding()
                .wrappedInNavigationViewToMkaeDismissable{
                    paletteToEdit = nil
                }
        }
        .sheet(isPresented: $managing){
            PaletteManager()
        }
    }
    
    @State private var paletteToEdit : Palette?
    @State private var managing = false
    
    var rollTransition : AnyTransition {
        AnyTransition.asymmetric(
            insertion: .offset(x:0,y:emojiFontSize),
            removal: .offset(x:0,y:-emojiFontSize)
        )
    }
   
}

struct ScrollingEmojisView :  View {
    let emojis : String
    var body: some View {
        
        ScrollView(.horizontal){
            HStack{
                ForEach(emojis.map{String($0)},id:\.self){ emoji in
                    Text(emoji)
                        .onDrag{
                            NSItemProvider(object: emoji as NSString)
                        }
                }
            }.padding()
        }
    }
}

