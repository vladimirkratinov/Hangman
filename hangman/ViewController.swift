//
//  ViewController.swift
//  hangman
//
//  Created by Vladimir Kratinov on 2022/1/17.
//

import UIKit
import Gifu

class ViewController: UIViewController {
       
    var levelLabel: UILabel!
    var scoreLabel: UILabel!
    var mistakesLabel: UILabel!
    var hintLabel: UILabel!
    
    var currentAnswer: UITextField!
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    var pictures = [String]()
    var animatedPictures = [String]()
    
    var hints = [String]()
    var solutions = [String]()
    var solutionLetters = [String]()
    var usedLetters = [String]()
    
    var solutionWord = ""
    var promptWord = ""
    var hintWord = ""
    
    let buttonsView = UIView()
    
    let hangmanGIF = GIFImageView()
    var hangmanJPG: UIImageView!
    
    var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView(frame: .zero)
        backgroundImageView.image = UIImage(named: "BACK2")
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImageView
    }()
    
    
    let levelContents = """
    CAT: meow-meow
    DOG: woof-woof
    """
    let abc = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","🙈","V","W","X","Y","Z","🙉"]
    
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
    
    var hangmanCounter: Int = 0
    
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
                
        levelLabel = UILabel()
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.text = "Level: \(level)"
        levelLabel.font = UIFont(name: "chalkduster", size: 18)
        levelLabel.textAlignment = .center
//        levelLabel.layer.borderWidth = 2
        view.addSubview(levelLabel)
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score: \(score)"
        scoreLabel.font = UIFont(name: "chalkduster", size: 18)
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
                letterButton.layer.cornerRadius = 25
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
        
            levelLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 240),
            levelLabel.leadingAnchor.constraint(equalTo: hangmanGIF.trailingAnchor, constant: 50),
            levelLabel.heightAnchor.constraint(equalToConstant: 50),
            levelLabel.widthAnchor.constraint(equalToConstant: 100),
            
            scoreLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor),
            scoreLabel.leadingAnchor.constraint(equalTo: hangmanGIF.trailingAnchor, constant: 50),
            scoreLabel.heightAnchor.constraint(equalToConstant: 50),
            scoreLabel.widthAnchor.constraint(equalToConstant: 100),
            
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
        
        performSelector(inBackground: #selector(gameLogic), with: nil)
    }
    
    //MARK: - loadImages()
    
    func loadImages() {
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
//        print("Pictures loaded: \(pictures)")
//        print("GIFs loaded: \(animatedPictures)")
    }
    
    //MARK: - gameLogic()
    
    @objc func gameLogic() {
        
        loadImages()
        
        DispatchQueue.main.async {
            self.hangmanJPG.alpha = 0
            self.hangmanGIF.alpha = 0
            self.hangmanJPG.image = nil
            self.hangmanGIF.image = nil
            print("prepare for reuse DONE!")
        }
        
        var lines = levelContents.components(separatedBy: "\n")
        lines.shuffle()
        
        for line in lines {
            let parts = line.components(separatedBy: ": ")
            let answer = parts[0]
            let hint = parts[1]
            
            solutions.append(answer)
            hints.append(hint)
        }
        performSelector(onMainThread: #selector(updateUI), with: nil, waitUntilDone: false)
        
    }
    
    //MARK: - updateUI()
    
    @objc func updateUI() {
        solutionWord = solutions[level - 1]
        hintWord = hints[level - 1]
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
            for i in 0..<self.abc.count {
                self.letterButtons[i].setTitle(self.abc[i], for: .normal)
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
            self?.score = 0
            self?.hangmanCounter = 0
            self?.solutions.removeAll()
            self?.hints.removeAll()
            self?.solutionLetters.removeAll()
            self?.pictures.removeAll()
            self?.animatedPictures.removeAll()
            self?.gameLogic()
            print("RESTART TAPPED")
        }
    }
    
    //MARK: - restartTapped()
    
    @objc func restartTapped(_ sender: UIButton) {
        resetLevel()
    }
    
    //MARK: - gameOverTapped()
    
    func gameOverTapped(action: UIAlertAction) {
        resetLevel()
    }
    
    //MARK: - finishTapped
    
    func finishTapped(action: UIAlertAction) {
        DispatchQueue.main.async { [weak self] in
            self?.hintLabel.text = "Your score: \(self!.score)"
            self?.currentAnswer.text = "Congratulations!"
            self?.hangmanGIF.animate(withGIFNamed: self!.animatedPictures[8])
            self?.hangmanGIF.updateImageIfNeeded()
            self?.hangmanJPG.alpha = 0
            self?.hangmanGIF.alpha = 1
            self?.buttonsView.isHidden = true
        }
    }
   
    //MARK: - letterTapped()
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        activatedButtons.append(sender)
        usedLetters.append(buttonTitle)
        sender.isHidden = true
        
        let filteredSolutions = solutionLetters.filter {$0 == buttonTitle}
//        print("Solution word: \(solutionWord)")
//        print("SolutionLetters: \(solutionLetters)")
//        print("Used Letters: \(usedLetters)")
//        print("Filtered List: \(filteredSolutions)")
        
        //Checking filtered list for used letters
        if filteredSolutions.isEmpty {
            performSelector(onMainThread: #selector(hangmanCounterOperating), with: nil, waitUntilDone: false)
            print("wrong letter.")
        } else {
            print("correct letter.")
        }
        
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
                    //levels finished check:
                    if (level - 1) < (solutions.count - 1) {
                        //next level
                        level += 1
                        //delete solution Letters for filtering:
                        solutionLetters.removeAll()
                    } else {
                        //game over(win)
                        let ac = UIAlertController(title: "Congratulations!", message: "Winner", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Finish", style: .destructive, handler: finishTapped))
                        present(ac, animated: true)
                    }
                    //updating UI after 1 second delay, to show the whole correct word
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.performSelector(onMainThread: #selector(self.updateUI), with: nil, waitUntilDone: false)
                    }
                }
            }
        }
    }
    
    //MARK: - hangmanCounterOperating()
    
    @objc func hangmanCounterOperating() {
        
        hangmanCounter += 1
        
        switch hangmanCounter {
        
        case 1:
            hangmanGIF.animate(withGIFNamed: animatedPictures[hangmanCounter - 1])
            hangmanJPG.alpha = 0
            hangmanGIF.alpha = 1
            print("hangmanCounter in SWITCH condition = 1")
            hangmanGIF.updateImageIfNeeded()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.hangmanGIF.stopAnimatingGIF()
                self.hangmanGIF.alpha = 0
                self.hangmanJPG.image = UIImage(named: self.pictures[self.hangmanCounter - 1])
                self.hangmanJPG.alpha = 1
                self.hangmanGIF.prepareForReuse()
            }
        case 2:
            hangmanGIF.animate(withGIFNamed: animatedPictures[hangmanCounter - 1])
            hangmanJPG.alpha = 0
            hangmanGIF.alpha = 1
            print("hangmanCounter in SWITCH condition = 2")
            hangmanGIF.updateImageIfNeeded()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.hangmanGIF.stopAnimatingGIF()
                self.hangmanGIF.alpha = 0
                self.hangmanJPG.image = UIImage(named: self.pictures[self.hangmanCounter - 1])
                self.hangmanJPG.alpha = 1
                self.hangmanGIF.prepareForReuse()
            }
        case 3:
            hangmanGIF.animate(withGIFNamed: animatedPictures[hangmanCounter - 1])
            hangmanJPG.alpha = 0
            hangmanGIF.alpha = 1
            print("hangmanCounter in SWITCH condition = 3")
            hangmanGIF.updateImageIfNeeded()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.hangmanGIF.stopAnimatingGIF()
                self.hangmanGIF.alpha = 0
                self.hangmanJPG.image = UIImage(named: self.pictures[self.hangmanCounter - 1])
                self.hangmanJPG.alpha = 1
                self.hangmanGIF.prepareForReuse()
            }
        case 4:
            hangmanGIF.animate(withGIFNamed: animatedPictures[hangmanCounter - 1])
            hangmanJPG.alpha = 0
            hangmanGIF.alpha = 1
            print("hangmanCounter in SWITCH condition = 4")
            hangmanGIF.updateImageIfNeeded()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.hangmanGIF.stopAnimatingGIF()
                self.hangmanGIF.alpha = 0
                self.hangmanJPG.image = UIImage(named: self.pictures[self.hangmanCounter - 1])
                self.hangmanJPG.alpha = 1
                self.hangmanGIF.prepareForReuse()
            }
        case 5:
            hangmanGIF.animate(withGIFNamed: animatedPictures[hangmanCounter - 1])
            hangmanJPG.alpha = 0
            hangmanGIF.alpha = 1
            print("hangmanCounter in SWITCH condition = 5")
            hangmanGIF.updateImageIfNeeded()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.hangmanGIF.stopAnimatingGIF()
                self.hangmanGIF.alpha = 0
                self.hangmanJPG.image = UIImage(named: self.pictures[self.hangmanCounter - 1])
                self.hangmanJPG.alpha = 1
                self.hangmanGIF.prepareForReuse()
            }
        case 6:
            hangmanGIF.animate(withGIFNamed: animatedPictures[hangmanCounter - 1])
            hangmanJPG.alpha = 0
            hangmanGIF.alpha = 1
            print("hangmanCounter in SWITCH condition = 6")
            hangmanGIF.updateImageIfNeeded()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.hangmanGIF.stopAnimatingGIF()
                self.hangmanGIF.alpha = 0
                self.hangmanJPG.image = UIImage(named: self.pictures[self.hangmanCounter - 1])
                self.hangmanJPG.alpha = 1
                self.hangmanGIF.prepareForReuse()
            }
        case 7:
            hangmanGIF.animate(withGIFNamed: animatedPictures[hangmanCounter - 1])
            hangmanJPG.alpha = 0
            hangmanGIF.alpha = 1
            print("hangmanCounter in SWITCH condition = 7")
            hangmanGIF.updateImageIfNeeded()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.hangmanGIF.stopAnimatingGIF()
                self.hangmanGIF.alpha = 0
                self.hangmanJPG.image = UIImage(named: self.pictures[self.hangmanCounter - 1])
                self.hangmanJPG.alpha = 1
                self.hangmanGIF.prepareForReuse()
            }
        case 8:
            hangmanGIF.animate(withGIFNamed: animatedPictures[hangmanCounter - 1])
            hangmanJPG.alpha = 0
            hangmanGIF.alpha = 1
            print("hangmanCounter in SWITCH condition = 8")
            hangmanGIF.updateImageIfNeeded()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.hangmanGIF.stopAnimatingGIF()
                self.hangmanGIF.alpha = 0
                self.hangmanJPG.image = UIImage(named: self.pictures[self.hangmanCounter - 1])
                self.hangmanJPG.alpha = 1
                self.hangmanGIF.prepareForReuse()
            }
        case 9:
            //GAME OVER:
            hangmanGIF.animate(withGIFNamed: animatedPictures[hangmanCounter - 1])
            hangmanJPG.alpha = 0
            hangmanGIF.alpha = 1
            print("hangmanCounter in SWITCH condition = 9")
            hangmanGIF.updateImageIfNeeded()
            
            let ac = UIAlertController(title: "GAME OVER", message: "You Lost :(", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: gameOverTapped))
            present(ac, animated: true)

        default:
            print("hangmanCounter in SWITCH condition = 0")
        }
    }
}
