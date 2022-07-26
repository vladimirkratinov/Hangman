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
    var menuController = MenuController()
    
    var hangmanGIF = GIFImageView()
    var hangmanJPG: UIImageView!
    
    var levelLabel: UILabel!
    var difficultyLabel: UILabel!
    var scoreLabel: UILabel!
    var mistakesLabel: UILabel!
    var hintLabel: UILabel!
    
    var currentAnswer: UITextField!
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    var muteButton = MuteButton()
    var backButton = UIButton(type: .system)
    
    var letterButton = HighlightedButtonOrange(type: .system)
    var restartButton = HighlightedButtonRed(type: .system)
    var hintButton = HighlightedButtonRed(type: .system)
    
    var solutionLetters = [String]()
    var usedLetters = [String]()
    
    var solutionWord = ""
    var promptWord = ""
    var hintWord = ""
    
    let buttonsView = UIView()
    
    var backImgName: String = "BACK"

    var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView(frame: .zero)
        backgroundImageView.image = UIImage(named: "BACK1")
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImageView
    }()
    
    var insideIndex = 0
    var counter: Int = 0
    var difficultLevelLabel: Int = 1
    
    var hintCounter: Int = 7 {
        didSet {
            hintButton.setTitle("Hint (\(hintCounter))", for: .normal)
        }
    }
    
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
        
    //MARK: - loadView()
    
    override func loadView() {
        view = UIView()
        view.sizeToFit()
        view.insertSubview(backgroundImageView, at: 0)
        
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        muteButton.setImage(UIImage(systemName: "speaker"), for: .normal)
        muteButton.setImage(UIImage(systemName: "speaker.slash"), for: .selected)
        muteButton.layer.cornerRadius = 10
        muteButton.tintColor = UIColor.black
        muteButton.backgroundColor = UIColor.orange
        //shadows {
        muteButton.layer.shadowColor = UIColor.black.cgColor
        muteButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        muteButton.layer.shadowRadius = 1
        muteButton.layer.shadowOpacity = 1.0
        muteButton.layer.shouldRasterize = true
        muteButton.layer.rasterizationScale = UIScreen.main.scale
        //shadows }
        muteButton.addTarget(self, action: #selector(muteTapped), for: .touchUpInside)
        view.addSubview(muteButton)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("<<", for: .normal)
        backButton.titleLabel?.font = UIFont(name: "chalkduster", size: 20)
        backButton.layer.cornerRadius = 10
        backButton.tintColor = UIColor.black
        backButton.backgroundColor = UIColor.orange
        //shadows {
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        backButton.layer.shadowRadius = 1
        backButton.layer.shadowOpacity = 1.0
        backButton.layer.shouldRasterize = true
        backButton.layer.rasterizationScale = UIScreen.main.scale
        //shadows }
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        hangmanGIF.translatesAutoresizingMaskIntoConstraints = false
        hangmanGIF.alpha = 1
        view.addSubview(hangmanGIF)
        
        hangmanJPG = UIImageView()
        hangmanJPG.translatesAutoresizingMaskIntoConstraints = false
        hangmanJPG.alpha = 0
        view.addSubview(hangmanJPG)
        
        difficultyLabel = UILabel()
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        difficultyLabel.text = "EASY"
        difficultyLabel.font = UIFont(name: "chalkduster", size: 20)
        difficultyLabel.textAlignment = .center
        view.addSubview(difficultyLabel)
                
        levelLabel = UILabel()
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.text = "Level: \(level)"
        levelLabel.font = UIFont(name: "chalkduster", size: 16)
        levelLabel.textAlignment = .center
        view.addSubview(levelLabel)
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score: \(score)"
        scoreLabel.font = UIFont(name: "chalkduster", size: 16)
        scoreLabel.textAlignment = .center
        view.addSubview(scoreLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.text = "COOKIE"
        currentAnswer.font = UIFont(name: "chalkduster", size: 30)
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 40)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        hintLabel = UILabel()
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.text = "Hint: There will be a hit"
        hintLabel.font = UIFont(name: "chalkduster", size: 15)
        hintLabel.textAlignment = .center
        view.addSubview(hintLabel)
        
        hintButton.translatesAutoresizingMaskIntoConstraints = false
        hintButton.setTitle("Hint (\(hintCounter))", for: .normal)
        hintButton.titleLabel?.font = UIFont(name: "chalkduster", size: 20)
        hintButton.tintColor = UIColor.white
        hintButton.backgroundColor = UIColor.orange
        hintButton.layer.cornerRadius = 10
        hintButton.layer.shadowColor = UIColor.black.cgColor
        hintButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        hintButton.layer.shadowRadius = 1
        hintButton.layer.shadowOpacity = 1.0
        hintButton.layer.shouldRasterize = true
        hintButton.layer.rasterizationScale = UIScreen.main.scale
        hintButton.addTarget(self, action: #selector(hintTapped), for: .touchUpInside)
        view.addSubview(hintButton)
        
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        restartButton.setTitle("Restart", for: .normal)
        restartButton.titleLabel?.font = UIFont(name: "chalkduster", size: 20)
        restartButton.tintColor = UIColor.white
        restartButton.backgroundColor = UIColor.orange
        restartButton.layer.cornerRadius = 10
        restartButton.layer.shadowColor = UIColor.black.cgColor
        restartButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        restartButton.layer.shadowRadius = 1
        restartButton.layer.shadowOpacity = 1.0
        restartButton.layer.shouldRasterize = true
        restartButton.layer.rasterizationScale = UIScreen.main.scale
        restartButton.addTarget(self, action: #selector(restartTapped), for: .touchUpInside)
        view.addSubview(restartButton)
        
        //buttonsView
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        let width = 55
        let height = 50

        for row in 0..<4 {
            for column in 0..<7 {
                let customColor = UIColor(red: 0.10, green: 0.74, blue: 0.61, alpha: 1.00)
                letterButton = HighlightedButtonOrange(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                letterButton.titleLabel?.font = UIFont(name: "chalkduster", size: 30)
                letterButton.tintColor = UIColor.black
                letterButton.backgroundColor = customColor
                letterButton.layer.borderWidth = 2
                letterButton.layer.cornerRadius = 15
                letterButton.layer.shadowColor = UIColor.black.cgColor
                letterButton.layer.shadowOffset = CGSize(width: 5, height: 5)
                letterButton.layer.shadowRadius = 1
                letterButton.layer.shadowOpacity = 1.0
                letterButton.layer.shouldRasterize = true
                letterButton.layer.rasterizationScale = UIScreen.main.scale
//                letterButton.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
//                buttonsView.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                
                
                //MARK: - borders
                
//                backButton.layer.borderWidth = 2
//                muteButton.layer.borderWidth = 2
//                restartButton.layer.borderWidth = 2
//                hintButton.layer.borderWidth = 2
                
                //optional borders:
//                buttonsView.layer.borderWidth = 2
//                hangmanGIF.layer.borderWidth = 2
//                hangmanJPG.layer.borderWidth = 2
//                difficultyLabel.layer.borderWidth = 2
//                levelLabel.layer.borderWidth = 2
//                scoreLabel.layer.borderWidth = 2
//                currentAnswer.layer.borderWidth = 2
//                hintLabel.layer.borderWidth = 2
//                restartButton.layer.borderWidth = 2
//                hintButton.layer.borderWidth = 2
            }
        }
        
        //MARK: - Constraints:
        
        NSLayoutConstraint.activate([
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            
            muteButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            muteButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            muteButton.heightAnchor.constraint(equalToConstant: 40),
            muteButton.widthAnchor.constraint(equalToConstant: 40),
            
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
            currentAnswer.heightAnchor.constraint(equalToConstant: 50),
            
            hintLabel.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 10),
            hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hintLabel.heightAnchor.constraint(equalToConstant: 30),
            
            hintButton.topAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: 20),
            hintButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: -70),
            hintButton.widthAnchor.constraint(equalToConstant: 100),
            hintButton.heightAnchor.constraint(equalToConstant: 50),
            
            restartButton.topAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: 20),
            restartButton.leadingAnchor.constraint(equalTo: hintButton.trailingAnchor, constant: 40),
            restartButton.widthAnchor.constraint(equalToConstant: 100),
            restartButton.heightAnchor.constraint(equalToConstant: 50),
            
            buttonsView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 20),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            buttonsView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    //MARK: - viewWillAppear()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLevelLabel()        
        performSelector(inBackground: #selector(gameLogic), with: nil)
    }
    
    //MARK: - gameLogic
    
    @objc func gameLogic() {
            levelContent.loadImages()
            levelContent.loadDifficultyLevel()
            performSelector(onMainThread: #selector(updateUI), with: nil, waitUntilDone: false)
    }
    
    //MARK: - backButtonTapped
    
    @objc func backButtonTapped() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    //MARK: - updateLevelLabel
    
    func updateLevelLabel() {
        switch difficultLevelLabel {
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
    
    //MARK: - updateUI
    
    @objc func updateUI() {
        
        resetABCbuttons()
        
        solutionWord = levelContent.solutions[level - 1]
        hintWord = levelContent.hints[level - 1]
        
        promptWord = ""
        
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
    
    //MARK: - resetLevel
    
    func resetLevel() {
        hangmanGIF.stopAnimatingGIF()
        hangmanGIF.prepareForReuse()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [ weak self ] in
            self?.hangmanJPG.image = nil
            self?.hangmanGIF.image = nil
            self?.hangmanJPG.alpha = 0
            self?.hangmanGIF.alpha = 0
            
            self?.level = 1
            self?.levelContent.difficultyLevel = self!.difficultLevelLabel
            self?.difficultLevelLabel = self!.difficultLevelLabel
            self?.score = 0
            self?.counter = 0
            self?.hintCounter = 7
            
            self?.backgroundImageView.image = UIImage(named: "\(self!.backImgName)\(self!.counter + 1)")
            
            self?.levelContent.solutions.removeAll()
            self?.levelContent.hints.removeAll()
            self?.solutionLetters.removeAll()
            self?.levelContent.pictures.removeAll()
            self?.levelContent.animatedPictures.removeAll()
            
            self?.gameLogic()
            self?.resetABCbuttons()
            
            self?.buttonsView.isHidden = false
            self?.hintButton.isHidden = false
            self?.hintButton.isEnabled = true
            }
        }
    
    //MARK: - resetABCbuttons
    
    func resetABCbuttons() {
        let abc = levelContent.loadAlphabet()
        for (index, _) in abc.enumerated() {
            let i = abc.index(abc.startIndex, offsetBy: index)
            letterButtons[i].isHidden = false
            }
    }
    
    //MARK: - restartTapped
    
    @objc func restartTapped(_ sender: UIButton) {
        //tag for audioFX
        sender.tag = 2
        //AudioFX
        DispatchQueue.main.async {
            try? self.audioFX.playAudio(sender)
        }
        
        //animation
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
    
    //MARK: - muteTapped
    
    @objc func muteTapped(_ sender: MuteButton) {
        if sender.isSelected {
            sender.isSelected = false
            audioFX.audioPlayer?.play()
            audioFX.muted = false
        } else {
            sender.isSelected = true
            audioFX.audioPlayer?.stop()
            audioFX.muted = true
        }
    }
    
    //MARK: - hintTapped
    
    @objc func hintTapped(_ sender: UIButton) {
        
        //audioFX
        try? audioFX.openFile(file: "RubberDuck", type: "wav")
        
        guard let randomLetter = solutionWord.randomElement() else { return }
        let randomString = String(randomLetter)
        let abc = levelContent.loadAlphabet()

        //hide button when hints finished
        if hintCounter < 1 {
            sender.isEnabled = false
//            sender.isHidden = true
            //audioFX
            try? audioFX.openFile(file: "Bomp", type: "mp3")
        }
        
        //check hint conditions:
        if  !usedLetters.contains(randomString){
            usedLetters.append(randomString)
            score += 1
            hintCounter -= 1
            
            //hiding letterButton:
            for (index, letter) in abc.enumerated() {
                let i = abc.index(abc.startIndex, offsetBy: index)
                if letter == randomString {
                    letterButtons[i].isHidden = true
                }
            }
            
            //showing random letter in promptWord
            for (index, letter) in solutionWord.enumerated() {
                let strLetter = String(letter)
                
                if  usedLetters.contains(strLetter) {
                    let i = promptWord.index(promptWord.startIndex, offsetBy: index)
                    promptWord.remove(at: i)
                    promptWord.insert(contentsOf: String(strLetter), at: i)
                    currentAnswer.text = promptWord
                }
            }
            insideIndex += 1
            
            print(insideIndex)
            print("Used Letters: \(usedLetters)")
            print("Solution Word: \(solutionWord)")
            print("Random Letter: \(randomString)")
            
        
            //Check if words are equal:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.checkIfWordsAreEqual()
            }
        }
    }
       
    //MARK: - letterTapped
    
    @objc func letterTapped(_ sender: UIButton) {
        
//        hangmanGIF.prepareForReuse()
        
        //tag for audioFX
        sender.tag = 1
        //AudioFX
        DispatchQueue.main.async {
            try? self.audioFX.playAudio(sender)
        }
        
        //animation
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
        
        //buttonTitle
        guard let buttonTitle = sender.titleLabel?.text else { return }
        activatedButtons.append(sender)
        usedLetters.append(buttonTitle)
        
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
        
        //MARK: - if contains letter:
        
        for (index, letter) in solutionWord.enumerated() {
            let strLetter = String(letter)
            
            if buttonTitle.contains(strLetter) {
                let i = promptWord.index(promptWord.startIndex, offsetBy: index)
                promptWord.remove(at: i)
                promptWord.insert(contentsOf: buttonTitle, at: i)
                currentAnswer.text = promptWord
                score += 1
                
                //words match check:
                checkIfWordsAreEqual()
            }
        }
    }
    
    //MARK: - counter:
    
    func animationPart() {
        hangmanJPG.alpha = 0
        hangmanGIF.alpha = 1
        hangmanGIF.animate(withGIFNamed: levelContent.animatedPictures[counter - 1])
    }
   
    func nextPicturePart() {
        hangmanJPG.image = UIImage(named: levelContent.pictures[counter - 1])
        hangmanGIF.stopAnimatingGIF()
        hangmanGIF.prepareForReuse()
        hangmanGIF.alpha = 0
        hangmanJPG.alpha = 1
    }
    
    func countingProcess() {
        
        counter += 1
        
        switch counter {
        case 1:
            backgroundImageView.image = UIImage(named: "\(backImgName)\(counter + 1)")
            animationPart()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.nextPicturePart()
            }
        case 2:
            backgroundImageView.image = UIImage(named: "\(backImgName)\(counter + 1)")
            animationPart()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.nextPicturePart()
            }
        case 3:
            backgroundImageView.image = UIImage(named: "\(backImgName)\(counter + 1)")
            animationPart()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.nextPicturePart()
            }
        case 4:
            backgroundImageView.image = UIImage(named: "\(backImgName)\(counter + 1)")
            animationPart()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.nextPicturePart()
            }
        case 5:
            backgroundImageView.image = UIImage(named: "\(backImgName)\(counter + 1)")
            animationPart()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.nextPicturePart()
            }
        case 6:
            backgroundImageView.image = UIImage(named: "\(backImgName)\(counter + 1)")
            animationPart()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.nextPicturePart()
            }
        case 7:
            backgroundImageView.image = UIImage(named: "\(backImgName)\(counter + 1)")
            animationPart()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.nextPicturePart()
            }
        case 8:
            backgroundImageView.image = UIImage(named: "\(backImgName)\(counter)")
            animationPart()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                self.nextPicturePart()
//            }
        case 9:
            //MARK: - GAME OVER (LOST)
            
//            backgroundImageView.image = UIImage(named: "\(backImgName)\(counter + 1)")
            //audioFX
            try? audioFX.openFile(file: "DrumsetFalling", type: "mp3")
            
            animationPart()
            
            hintLabel.text = "Your score: \(score)"
            currentAnswer.text = "You Lost!"
            buttonsView.isHidden = true
            hintButton.isEnabled = false
            
        default:
            counter = 0
            backgroundImageView.image = UIImage(named: "back1")
        }
    }
    
    //MARK: - checkIfWordsAreEqual
    
    func checkIfWordsAreEqual() {
        //check if hintWord == correctWord:
        if promptWord == solutionWord {
            
            if level >= (levelContent.solutions.count) {
                
                //difficultyLevel + 1
                if levelContent.difficultyLevel < 4 {
                    levelContent.difficultyLevel += 1
                    difficultLevelLabel += 1
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
                        self?.hintButton.isHidden = true
                    }
                }
            }
            
            //next level
            if level < (levelContent.solutions.count) {
                level += 1
                
                //delete solution Letters for filtering:
                solutionLetters.removeAll()
                
                DispatchQueue.main.async {
                    //audioFX
                    try? self.audioFX.openFile(file: "Magic", type: "wav")
                }
                
                //updating UI after 1 second delay, to show the whole correct word
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.performSelector(onMainThread: #selector(self.updateUI), with: nil, waitUntilDone: false)
                }
            }
        }
    }

}
