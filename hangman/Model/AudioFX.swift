//
//  AudioFX.swift
//  hangman
//
//  Created by Vladimir Kratinov on 2022/1/21.
//

import UIKit
import AVFoundation

struct AudioFX {
    
    var audioPlayer: AVAudioPlayer?
    var muted = false
    
    mutating func openFile(file: String, type: String) throws {
        
        enum AudioError: Error {
            case FileNotExist
        }
        
        let pathToSound = Bundle.main.path(forResource: file, ofType: type)!
        let url = URL(fileURLWithPath: pathToSound)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            if muted {
                audioPlayer?.volume = 0
            } else {
                audioPlayer?.volume = 0.5
            }
            audioPlayer?.play()
        } catch {
            print("\(file).\(type) was not found.")
            throw AudioError.FileNotExist
        }
    }
    
    mutating func playAudio(_ sender: UIButton) throws {
        
        let selectedButton = sender.tag
        
        switch selectedButton {
        //letterButton
        case 1:
            let randomizer = Int.random(in: 1...3)
            switch randomizer {
            case 1:
                try? openFile(file: "WoodHit_1", type: "wav")
            case 2:
                try? openFile(file: "WoodHit_2", type: "wav")
            case 3:
                try? openFile(file: "WoodHit_3", type: "wav")
            case 4:
                try? openFile(file: "RubberDuck", type: "wav")
            default:
                print("default")
            }
        //restartButton
        case 2:
            try? openFile(file: "Boing", type: "mp3")
        default:
            print("sound was not found")
        }
    }
}
