//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Nathan Getachew on 1/24/23.
//

import SwiftUI
import Combine
import UniformTypeIdentifiers

extension UTType {
    static let emojiart = UTType(exportedAs: "com.nathang.emojiart")
}

class EmojiArtDocument : ObservableObject, ReferenceFileDocument {
    static var readableContentTypes : [UTType] {
        get {
            [UTType.emojiart]
        }
    }
    static var writableContentTypes: [UTType] {
        get {
            [UTType.emojiart]
        }
    }
    
    required init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            emojiArt = try EmojiArtModel(json: data)
            fetchBackgroundImage()
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func snapshot(contentType: UTType) throws -> Data {
        try emojiArt.json()
    }
    
    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: snapshot)
    }
        
    
    @Published private(set) var emojiArt : EmojiArtModel {
        didSet {
//            scheduleAutosave()
            if emojiArt.background != oldValue.background{
                fetchBackgroundImage()
            }
        }
    }
    
    
    
    init(){
//        if let url = Autosave.url, let autosavedEmojiArt = try? EmojiArtModel(url: url) {
//            emojiArt = autosavedEmojiArt
//            fetchBackgroundImage()
//        } else
//        {
            emojiArt = EmojiArtModel()
        
//        }
    }
    
// MARK: - Autosave done manually
//    private struct Autosave {
//        static let filename = "Autosaved.emojiart"
//        static var url: URL? {
//            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//            return documentDirectory?.appendingPathComponent(filename)
//        }
//        static let coalescingInterval = 5.0
//    }
//
//    private var autosaveTimer: Timer?
//
//    private func scheduleAutosave(){
//        autosaveTimer?.invalidate()
//        Timer.scheduledTimer(withTimeInterval: Autosave.coalescingInterval, repeats: true){_ in
//            self.autosave()
//        }
//    }
//
//    private func autosave() {
//        if let url = Autosave.url {
//            save (to: url)
//        }
//    }
//
//    private func save(to url:URL){
//        let thisfunction = "\(String(describing: self)).\(#function)"
//        do {
//            let data: Data = try emojiArt.json()
//            print("\(thisfunction) json = \(String (data: data, encoding: .utf8) ?? "nil")")
//            try data.write(to: url)
//            print("\(thisfunction) success!")
//        } catch let encodingError where encodingError is EncodingError {
//            print ("\(thisfunction) couldn't encode EmojiArt as JSON because \(encodingError.localizedDescription)")
//        } catch  {
//            print("\(thisfunction) error= \(error)")
//        }
//
//    }
    
    var emojis: [EmojiArtModel.Emoji] { emojiArt.emojis }
    var background: EmojiArtModel.Background { emojiArt.background }
    
    
    
    @Published var backgroundImage : UIImage?
    @Published var backgroundImageFetchStatus =  BackgroundImageFetchStatus.idle
    
    enum BackgroundImageFetchStatus : Equatable {
        case idle
        case fetching
        case failed(URL)
    }

    private var backgroundImageFetchCancellable : AnyCancellable?
    
    private func fetchBackgroundImage(){
        backgroundImage = nil
        switch emojiArt.background {
            
        case .blank:
            break
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .url(let url):
            backgroundImageFetchStatus = BackgroundImageFetchStatus.fetching
            backgroundImageFetchCancellable?.cancel()
            
// MARK: - USING PUBLISHER TO DO FETHING
            let session  = URLSession.shared
            let publisher = session.dataTaskPublisher(for: url)
                .map{ (data, urlResponse) in
                    UIImage(data: data)
                }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
            backgroundImageFetchCancellable = publisher
//                .assign(to: \EmojiArtDocument.backgroundImage, on: self)
                .sink{ [weak self] image in
                    self?.backgroundImage = image
                    self?.backgroundImageFetchStatus = image != nil ? .idle : .failed(url)
                    
                }
                
            
            
            
            
// MARK: - USING DISPACTCH QUEUE TO DO FETHING
//            DispatchQueue.global(qos: .userInitiated).async {
//                let imageData = try? Data(contentsOf: url)
//
//                DispatchQueue.main.async { [weak self] in
//                    if self?.emojiArt.background == EmojiArtModel.Background.url(url){
//                        self?.backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
//                        if imageData != nil {
//                            self?.backgroundImage = UIImage(data: imageData!)
//                        }
//                        if self?.backgroundImage == nil {
//                            self?.backgroundImageFetchStatus = .failed(url)
//                        }
//                    }
//                }
//            }
            
        }
    }
    
    
    // MARK: - Intent(s)
    func setBackground(_ background: EmojiArtModel.Background,undoManager:UndoManager?) {
        undoablyPerform(operation: "Set Background", with: undoManager) {
            emojiArt.background = background
        }
    }
    
    
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat,undoManager:UndoManager?) {
        undoablyPerform(operation: "Add \(emoji)", with: undoManager) {
            emojiArt.addEmoji(emoji, at: location, size: Int(size))
        }
    }
    
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize,undoManager:UndoManager?) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            undoablyPerform(operation: "Move", with: undoManager) {
                emojiArt.emojis[index].x += Int(offset.width)
                emojiArt.emojis[index].y += Int(offset.height)
            }
        }
    }
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat,undoManager:UndoManager?) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            undoablyPerform(operation: "Scale", with: undoManager) {
                emojiArt.emojis[index].size = Int ((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
            }
        }
    }


    // MARK: - Undo
    
    private func undoablyPerform(operation:String, with undoManager:UndoManager? = nil,doit:()->Void){
        let oldEmojiArt = emojiArt
        doit()
        undoManager?.registerUndo(withTarget: self){ myself in
            myself.undoablyPerform(operation: operation, with: undoManager){
                myself.emojiArt = oldEmojiArt
            }
        }
        undoManager?.setActionName(operation)
    }

}
