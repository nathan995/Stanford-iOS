//
//  EmojiArtModel.swift
//  EmojiArt
//
//  Created by Nathan Getachew on 1/24/23.
//

import Foundation

struct EmojiArtModel : Codable {
    
    var background =  Background.blank
    
    private var uniqueEmojId : Int = 0
    
    var emojis = [Emoji]()
    
    struct Emoji : Identifiable, Hashable, Codable  {
        let text: String
        var x: Int
        var y: Int
        var size: Int
        var id: Int
        
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    
    
    // prevent default init from setting emojis
    init(){}
    
    init (json: Data) throws {
        self = try JSONDecoder().decode(EmojiArtModel.self, from: json)
    }
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try EmojiArtModel(json: data)
    }
    
    func json() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
    mutating func addEmoji(_ text:String, at location :(x:Int,y:Int), size:Int){
        uniqueEmojId+=1
        emojis.append(Emoji(text: text, x: location.x, y: location.y, size: size,id: uniqueEmojId))
    }
    
    
    
}
