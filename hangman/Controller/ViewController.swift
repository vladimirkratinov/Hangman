//
//  ViewController.swift
//  hangman
//
//  Created by Vladimir Kratinov on 2022/1/17.
//

import UIKit
import Gifu
import AVFoundation

class ViewController: UIViewController {
    
    var audioFX = AudioFX()
       
    var levelContent = LevelContent()
    
    var hangmanGIF = GIFImageView()
    var hangmanJPG: UIImageView!
    
    var counter: Int = 0
    
    var levelLabel: UILabel!
    var difficultyLabel: UILabel!
    var scoreLabel: UILabel!
    var mistakesLabel: UILabel!
    var hintLabel: UILabel!
    
    var currentAnswer: UITextField!
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    var solutionLetters = [String]()
    var usedLetters = [String]()
    
    var solutionWord = ""
    var promptWord = ""
    var hintWord = ""
    
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
    
    //MARK: - loadView()
    
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
        restartButton.addTarget(self, action: #selector(restartTapped), for: .touchUpInside)
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
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
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
    
    //MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let pathToSound = Bundle.main.path(forResource: "background", ofType: "mp3")!
//        let url = URL(fileURLWithPath: pathToSound)
//
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//            audioPlayer?.play()
//        } catch {
//            print(error.localizedDescription)
//        }
        
        performSelector(inBackground: #selector(gameLogic), with: nil)
        
    }
    
    //MARK: - gameLogic()
    
    @objc func gameLogic() {
            levelContent.loadImages()
            levelContent.loadDifficultyLevel()
            performSelector(onMainThread: #selector(updateUI), with: nil, waitUntilDone: false)
    }
    
    //MARK: - updateUI()
    
    @objc func updateUI() {
        //Index out of range(?)
        solutionWord = levelContent.solutions[level - 1]
        hintWord = levelContent.hints[level - 1]
        promptWord = ""
//        print(levelContent.solutions)
//        print(solutionWord)
//        print(hintWord)
        
        for letter in solutionWord {
            let strLetter = String(letter)
            solutionLetters.append(strLetter)
        }
        
        for button in activatedButtons {
            button.isHidden = false
        }
        
        activatedButtons.removeAll()
        usedLetters.removeAll()
        
        DispatchQueue.main.async {
            for letter in self.solutionWord {
                let strLetter = String(letter)
                
                if self.usedLetters.contains(strLetter) {
                    self.promptWord += strLetter
                } else {
                    self.promptWord += "•"
                }
            }
            self.currentAnswer.text = self.promptWord
            self.currentAnswer.font = UIFont(name: "chalkduster", size: 40)
            self.hintLabel.text = "Hint: \(self.hintWord)"
            
            //buttons ABC... titles
            let abc = self.levelContent.loadAlphabet()
            
            for i in 0..<abc.count {
                self.letterButtons[i].setTitle(abc[i], for: .normal)
            }
        }
    }
    
    //MARK: - resetLevel()
    
    func resetLevel() {
        hangmanGIF.stopAnimatingGIF()
        hangmanGIF.updateImageIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [ weak self ] in
            self?.hangmanJPG.image = nil
            self?.hangmanGIF.image = nil
            self?.hangmanJPG.alpha = 0
            self?.hangmanGIF.alpha = 0
            self?.buttonsView.isHidden = false
            self?.level = 1
            self?.levelContent.difficultyLevel = 1
            self?.difficulLevelLabel = 1
            self?.score = 0
            self?.counter = 0
            self?.levelContent.solutions.removeAll()
            self?.levelContent.hints.removeAll()
            self?.solutionLetters.removeAll()
            self?.levelContent.pictures.removeAll()
            self?.levelContent.animatedPictures.removeAll()
            self?.gameLogic()
//            print("RESTART TAPPED")
        }
    }
    
    //MARK: - restartTapped()
    
    @objc func restartTapped(_ sender: UIButton) {
        //tag for audioFX
        sender.tag = 2
        //AudioFX
        DispatchQueue.main.async {
            try? self.audioFX.playAudio(sender)
        }
        
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

            UIView.animate(withDuration: 2.0,
                                       delay: 0,
                                       usingSpringWithDamping: CGFloat(0.20),
                                       initialSpringVelocity: CGFloat(6.0),
                                       options: UIView.AnimationOptions.allowUserInteraction,
                                       animations: {
                                        sender.transform = CGAffineTransform.identity
                },
                                       completion: { Void in()  }
            )
        resetLevel()
    }
       
    //MARK: - letterTapped()
    
    @objc func letterTapped(_ sender: UIButton) {
        //tag for audioFX
        sender.tag = 1
        //AudioFX
        DispatchQueue.main.async {
            try? self.audioFX.playAudio(sender)
        }
        
        guard let buttonTitle = sender.titleLabel?.text else { return }
        activatedButtons.append(sender)
        usedLetters.append(buttonTitle)
        
        
        
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 1.0,
                                   delay: 0,
                                   usingSpringWithDamping: CGFloat(1.0),
                                   initialSpringVelocity: CGFloat(12.0),
                                   options: UIView.AnimationOptions.allowUserInteraction,
                                   animations: {
                                    sender.transform = CGAffineTransform.identity
            },
                                   completion: { Void in()  }
        )
        
        //hide tapped button after 0.3 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.isHidden = true
        }
//        print(levelContent.solutions)
//        print(levelContent.hints)
//        print("level: \(level)")
//        print("solutionsCount: \(levelContent.solutions.count)")
//        print(solutionLetters)
//        print(levelContent.solutions)
        
        //filtering solutins:
        let filteredSolutions = solutionLetters.filter {$0 == buttonTitle}
        //Checking filtered list for used letters:
        if filteredSolutions.isEmpty {
            
            DispatchQueue.main.async {
                self.countingProcess()
            }
        }
        
        //MARK: - if button = correct letter:
        
        for (index, letter) in solutionWord.enumerated() {
            let strLetter = String(letter)
            
            if buttonTitle.contains(strLetter) {
                let i = promptWord.index(promptWord.startIndex, offsetBy: index)
                promptWord.remove(at: i)
                promptWord.insert(contentsOf: buttonTitle, at: i)
                currentAnswer.text = promptWord
                score += 1
                
                //words match check:
                if promptWord == solutionWord {
                    
                    if level >= (levelContent.solutions.count) {
                        
                        //difficultyLevel + 1
                        if levelContent.difficultyLevel < 4 {
                            levelContent.difficultyLevel += 1
                            difficulLevelLabel += 1
                            levelContent.loadDifficultyLevel()
//                            print("LOAD DIFFICULTY +1")
            
                        } else {
                            //MARK: - GAME OVER (WIN)
                            DispatchQueue.main.async { [weak self] in
                                self?.hintLabel.text = "Your score: \(self!.score)"
                                self?.currentAnswer.text = "WINNER!"
                                self?.hangmanGIF.animate(withGIFNamed: self!.levelContent.animatedPictures[8])
                                self?.hangmanGIF.updateImageIfNeeded()
                                self?.hangmanJPG.alpha = 0
                                self?.hangmanGIF.alpha = 1
                                self?.buttonsView.isHidden = true
                            }
                        }
                    }
                    
                    //next level
                    if level < (levelContent.solutions.count) {
                        level += 1
                        
                        //delete solution Letters for filtering:
                        solutionLetters.removeAll()
                        
                        //updating UI after 1 second delay, to show the whole correct word
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.performSelector(onMainThread: #selector(self.updateUI), with: nil, waitUntilDone: false)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - hangmanCounter
    
    func animationPart() {
       hangmanGIF.animate(withGIFNamed: levelContent.animatedPictures[counter - 1])
       hangmanGIF.updateImageIfNeeded()
       hangmanJPG.alpha = 0
       hangmanGIF.alpha = 1
   }
   
   func nextPicturePart() {
       hangmanGIF.stopAnimatingGIF()
       hangmanGIF.prepareForReuse()
       hangmanGIF.alpha = 0
       hangmanJPG.alpha = 1
       hangmanJPG.image = UIImage(named: levelContent.pictures[counter - 1])
   }
    
    func countingProcess() {
        
        counter += 1
        
        switch counter {
        case 1:
            animationPart()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.nextPicturePart()
            }
        case 2:
            animationPart()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.nextPicturePart()
            }
        case 3:
            animationPart()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.nextPicturePart()
            }
        case 4:
            animationPart()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.nextPicturePart()
            }
        case 5:
            animationPart()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.nextPicturePart()
            }
        case 6:
            animationPart()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.nextPicturePart()
            }
        case 7:
            animationPart()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.nextPicturePart()
            }
        case 8:
            animationPart()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.nextPicturePart()
            }
        case 9:
            //MARK: - GAME OVER (LOST)
            animationPart()
            
            //audioFX
            DispatchQueue.global(qos: .background).async {
                try? self.audioFX.openFile(file: "DrumsetFalling", type: "mp3")
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.hintLabel.text = "Your score: \(self!.score)"
                self?.currentAnswer.text = "You Lost!"
                self?.hangmanGIF.animate(withGIFNamed: self!.levelContent.animatedPictures[8])
                self?.hangmanGIF.updateImageIfNeeded()
                self?.hangmanJPG.alpha = 0
                self?.hangmanGIF.alpha = 1
                self?.buttonsView.isHidden = true
            }
            
        default:
            counter = 0
        }
    }

}
