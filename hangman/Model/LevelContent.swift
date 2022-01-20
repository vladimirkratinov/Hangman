//
//  levelContent.swift
//  hangman
//
//  Created by Vladimir Kratinov on 2022/1/20.
//

import UIKit

struct LevelContent {
    
    var hints = [String]()
    var solutions = [String]()
    
    var pictures = [String]()
    var animatedPictures = [String]()
    
    var difficultyLevel: Int = 1
    
    //MARK: - loadAlphabet
    
    func loadAlphabet() -> [String] {
        let alphabetlFileURL = Bundle.main.url(forResource: "alphabet", withExtension: "txt")
        let alphabet = try! String(contentsOf: alphabetlFileURL!)
        let letter = alphabet.components(separatedBy: ",")
        return letter
    }
    
    //MARK: - loadDifficultyLevel
    
    mutating func loadDifficultyLevel() {
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(difficultyLevel)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
//                lines.sort()
//                print(lines)
//                print(lines.count)
                
                for line in lines {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let hint = parts[1]
//                    print(answer ?? "answer-NIL","-", hint ?? "hint-NIL")
                    
                    solutions.append(answer)
                    hints.append(hint)
                    
                    
                }
            }
        }
//        print("loadDifficultyLevel method: WORKED")
    }
    
    
    //MARK: - loadImages
    
    mutating func loadImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        if let items = try? fm.contentsOfDirectory(atPath: path) {
            
            for item in items {
                if item.hasSuffix(".jpg") {
                    pictures.append(item)
                    pictures.sort()
                }
                if item.hasSuffix(".gif") {
                    animatedPictures.append(item)
                    animatedPictures.sort()
                }
            }
        }
    }    
}

//extension Collection where Indices.Iterator.Element == Index {
//    public subscript(safe index: Index) -> Iterator.Element? {
//        return (startIndex <= index && index < endIndex) ? self[index] : nil
//    }
//}
