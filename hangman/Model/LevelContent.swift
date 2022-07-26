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
    var currentLevel: String = ""
    
    //MARK: - loadAlphabet
    
    func loadAlphabet() -> [String] {
        let letter = alphabet.components(separatedBy: ",")
        return letter
    }
    
    //MARK: - loadDifficultyLevel
    
    mutating func loadDifficultyLevel() {
        
        switch difficultyLevel {
        case 1:
            currentLevel = level1
        case 2:
            currentLevel = level2
        case 3:
            currentLevel = level3
        case 4:
            currentLevel = level4
        default:
            currentLevel = level1
        }
        
        var lines = currentLevel.components(separatedBy: "\n")
        lines.shuffle()
        
        for line in lines {
            let parts = line.components(separatedBy: ": ")
            let answer = parts[0]
            let hint = parts[1]
            
            solutions.append(answer)
            hints.append(hint)
        }
    }
    
    
    //MARK: - loadImages
    
    mutating func loadImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        if let items = try? fm.contentsOfDirectory(atPath: path) {
            
            for item in items {
                if item.hasPrefix("frame") && item.hasSuffix(".jpg") {
                    pictures.append(item)
                    pictures.sort()
                }
                if item.hasPrefix("frame") && item.hasSuffix(".gif") {
                    animatedPictures.append(item)
                    animatedPictures.sort()
                }
            }
        }
    }    
}
