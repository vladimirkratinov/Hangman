//
//  LoadView.swift
//  hangman
//
//  Created by Vladimir Kratinov on 2022/1/21.
//

import UIKit
import Gifu

class CustomView: UIViewController {
    
    var hangmanJPG: UIImageView!
    
    var levelLabel: UILabel!
    var difficultyLabel: UILabel!
    var scoreLabel: UILabel!
    var mistakesLabel: UILabel!
    var hintLabel: UILabel!
    
    var hangmanGIF: GIFImageView!
    
    var currentAnswer: UITextField!
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    let buttonsView = UIView()
    var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView(frame: .zero)
        backgroundImageView.image = UIImage(named: "BACK2")
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImageView
    }()
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level: Int = 1 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    
    var difficulLevelLabel: Int = 1 {
        didSet {
            switch difficulLevelLabel {
            case 1:
                difficultyLabel.text = "EASY"
            case 2:
                difficultyLabel.text = "NORMAL"
            case 3:
                difficultyLabel.text = "HARD"
            case 4:
                difficultyLabel.text = "EXTREME"
            default:
                difficultyLabel.text = "EASY"
            }
        }
    }

        override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        view.insertSubview(backgroundImageView, at: 0)
        
        
            
        hangmanGIF.translatesAutoresizingMaskIntoConstraints = false
//        hangmanGIF.layer.borderWidth = 2
        hangmanGIF.alpha = 1
        view.addSubview(hangmanGIF)
        
        hangmanJPG = UIImageView()
        hangmanJPG.translatesAutoresizingMaskIntoConstraints = false
//        hangmanJPG.layer.borderWidth = 2
        hangmanJPG.alpha = 0.0
        view.addSubview(hangmanJPG)
        
        difficultyLabel = UILabel()
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        difficultyLabel.text = "EASY"
        difficultyLabel.font = UIFont(name: "chalkduster", size: 20)
        difficultyLabel.textAlignment = .center
//        levelLabel.layer.borderWidth = 2
        view.addSubview(difficultyLabel)
                
        levelLabel = UILabel()
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.text = "Level: \(level)"
        levelLabel.font = UIFont(name: "chalkduster", size: 16)
        levelLabel.textAlignment = .center
//        levelLabel.layer.borderWidth = 2
        view.addSubview(levelLabel)
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score: \(score)"
        scoreLabel.font = UIFont(name: "chalkduster", size: 16)
        scoreLabel.textAlignment = .center
//        scoreLabel.layer.borderWidth = 2
        view.addSubview(scoreLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.text = "COOKIE"
        currentAnswer.font = UIFont(name: "chalkduster", size: 30)
        currentAnswer.textAlignment = .center
//        currentAnswer.layer.borderWidth = 2
        currentAnswer.font = UIFont.systemFont(ofSize: 40)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        hintLabel = UILabel()
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.text = "Hint: There will be a hit"
        hintLabel.font = UIFont(name: "chalkduster", size: 15)
        hintLabel.textAlignment = .center
//        hintLabel.layer.borderWidth = 2
        view.addSubview(hintLabel)
        
        let restartButton = HighlightedButtonRed(type: .system)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        restartButton.setTitle("Restart", for: .normal)
        restartButton.titleLabel?.font = UIFont(name: "chalkduster", size: 20)
        restartButton.layer.borderWidth = 2
        restartButton.layer.cornerRadius = 10
        restartButton.layer.shadowColor = UIColor.black.cgColor
        restartButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        restartButton.layer.shadowRadius = 1
        restartButton.layer.shadowOpacity = 1.0
        restartButton.tintColor = UIColor.white
        restartButton.backgroundColor = UIColor.orange
//        restartButton.addTarget(self, action: #selector(brains.restartTapped), for: .touchUpInside)
        view.addSubview(restartButton)
        
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
//        buttonsView.layer.borderWidth = 1
        view.addSubview(buttonsView)
        
        let width = 50
        let height = 50
        
        for row in 0..<4 {
            for column in 0..<7 {
                let letterButton = HighlightedButtonOrange(type: .system)
                letterButton.setTitle("W", for: .normal)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                letterButton.layer.borderWidth = 1
                letterButton.layer.cornerRadius = 15
                letterButton.layer.shadowColor = UIColor.black.cgColor
                letterButton.layer.shadowOffset = CGSize(width: 5, height: 5)
                letterButton.layer.shadowRadius = 1
                letterButton.layer.shadowOpacity = 1.0
                letterButton.titleLabel?.font = UIFont(name: "chalkduster", size: 30)
                letterButton.tintColor = UIColor.black
                letterButton.backgroundColor = UIColor(red: 0.10, green: 0.74, blue: 0.61, alpha: 1.00)
//                letterButton.addTarget(self, action: #selector(brains.letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
        //MARK: - Constraints:
        
        NSLayoutConstraint.activate([
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            hangmanGIF.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 140),
            hangmanGIF.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            hangmanGIF.heightAnchor.constraint(equalToConstant: 200),
            hangmanGIF.widthAnchor.constraint(equalToConstant: 200),
            
            hangmanJPG.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 140),
            hangmanJPG.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            hangmanJPG.heightAnchor.constraint(equalToConstant: 200),
            hangmanJPG.widthAnchor.constraint(equalToConstant: 200),
            
            difficultyLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 160),
            difficultyLabel.leadingAnchor.constraint(equalTo: hangmanGIF.trailingAnchor, constant: 30),
            difficultyLabel.heightAnchor.constraint(equalToConstant: 50),
            difficultyLabel.widthAnchor.constraint(equalToConstant: 120),
        
            levelLabel.topAnchor.constraint(equalTo: difficultyLabel.bottomAnchor),
            levelLabel.leadingAnchor.constraint(equalTo: hangmanGIF.trailingAnchor, constant: 30),
            levelLabel.heightAnchor.constraint(equalToConstant: 50),
            levelLabel.widthAnchor.constraint(equalToConstant: 120),
            
            scoreLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor),
            scoreLabel.leadingAnchor.constraint(equalTo: hangmanGIF.trailingAnchor, constant: 30),
            scoreLabel.heightAnchor.constraint(equalToConstant: 50),
            scoreLabel.widthAnchor.constraint(equalToConstant: 120),
            
            currentAnswer.topAnchor.constraint(equalTo: hangmanGIF.bottomAnchor, constant: 60),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            hintLabel.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 10),
            hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            restartButton.topAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: 20),
            restartButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            restartButton.widthAnchor.constraint(equalToConstant: 100),
            restartButton.heightAnchor.constraint(equalToConstant: 50),
            
            buttonsView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 20),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsView.widthAnchor.constraint(equalToConstant: 350),
            buttonsView.heightAnchor.constraint(equalToConstant: 200)
            
        ])
    }
    
}
