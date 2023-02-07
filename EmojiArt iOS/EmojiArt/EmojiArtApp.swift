//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Nathan Getachew on 1/24/23.
//

import SwiftUI

@main
struct EmojiArtApp: App {
//    @StateObject var document = EmojiArtDocument()
    @StateObject var paletteStore = PaletteStore(named: "Default")
    
    var body: some Scene {
        DocumentGroup (newDocument: {EmojiArtDocument()}) { config in
            EmojiArtDocumentView(document: config.document)
                .environmentObject(paletteStore)
        }
    }
}
