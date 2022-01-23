//
//  MenuView.swift
//  hangman
//
//  Created by Vladimir Kratinov on 2022/1/23.
//

import UIKit

class MenuController: UIViewController {
    
    var audioFX = AudioFX()
    var levelContent = LevelContent()
    
    var easyLevelButton = EasyLevelButton(type: .system)
    var normalLevelButton = NormalLevelButton(type: .system)
    var hardLevelButton = HardLevelButton(type: .system)
    var extremeLevelButton = ExtremeLevelButton(type: .system)
    
    var muteButton = MuteButton()
    
    let customColor = UIColor(red: 0.10, green: 0.74, blue: 0.61, alpha: 1.00)
    
    var levelLabel: UILabel!
    
    var difficultLevelLabel: Int = 1
    
    var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView(frame: .zero)
        backgroundImageView.image = UIImage(named: "BACK1")
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImageView
    }()
    
    override func loadView() {
        view = UIView()
        view.insertSubview(backgroundImageView, at: 0)
        
        //remember about shadow rasterization in buttons!
        
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        muteButton.setImage(UIImage(systemName: "speaker"), for: .normal)
        muteButton.setImage(UIImage(systemName: "speaker.slash"), for: .selected)
        muteButton.layer.cornerRadius = 10
        muteButton.tintColor = UIColor.black
        muteButton.backgroundColor = UIColor.orange
        muteButton.layer.shadowColor = UIColor.black.cgColor
        muteButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        muteButton.layer.shadowRadius = 1
        muteButton.layer.shadowOpacity = 1.0
        muteButton.layer.shouldRasterize = true
        muteButton.layer.rasterizationScale = UIScreen.main.scale
        muteButton.addTarget(self, action: #selector(muteTapped), for: .touchUpInside)
        view.addSubview(muteButton)
        
        levelLabel = UILabel()
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.text = "Chose Difficulty Level:"
        levelLabel.font = UIFont(name: "chalkduster", size: 20)
        levelLabel.textAlignment = .center
        view.addSubview(levelLabel)
        
        easyLevelButton.translatesAutoresizingMaskIntoConstraints = false
        easyLevelButton.setTitle("Easy", for: .normal)
        easyLevelButton.titleLabel?.font = UIFont(name: "chalkduster", size: 30)
        easyLevelButton.layer.cornerRadius = 10
        easyLevelButton.layer.shadowColor = UIColor.black.cgColor
        easyLevelButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        easyLevelButton.layer.shadowRadius = 1
        easyLevelButton.layer.shadowOpacity = 1.0
        easyLevelButton.tintColor = UIColor.black
        easyLevelButton.backgroundColor = customColor
        easyLevelButton.layer.shouldRasterize = true
        easyLevelButton.layer.rasterizationScale = UIScreen.main.scale
        easyLevelButton.tag = 1
        easyLevelButton.addTarget(self, action: #selector(levelButtonTapped), for: .touchUpInside)
        view.addSubview(easyLevelButton)
        
        normalLevelButton.translatesAutoresizingMaskIntoConstraints = false
        normalLevelButton.setTitle("Normal", for: .normal)
        normalLevelButton.titleLabel?.font = UIFont(name: "chalkduster", size: 30)
        normalLevelButton.layer.cornerRadius = 10
        normalLevelButton.layer.shadowColor = UIColor.black.cgColor
        normalLevelButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        normalLevelButton.layer.shadowRadius = 1
        normalLevelButton.layer.shadowOpacity = 1.0
        normalLevelButton.tintColor = UIColor.black
        normalLevelButton.backgroundColor = customColor
        normalLevelButton.layer.shouldRasterize = true
        normalLevelButton.layer.rasterizationScale = UIScreen.main.scale
        normalLevelButton.tag = 2
        normalLevelButton.addTarget(self, action: #selector(levelButtonTapped), for: .touchUpInside)
        view.addSubview(normalLevelButton)
        
        hardLevelButton.translatesAutoresizingMaskIntoConstraints = false
        hardLevelButton.setTitle("Hard", for: .normal)
        hardLevelButton.titleLabel?.font = UIFont(name: "chalkduster", size: 30)
        hardLevelButton.layer.cornerRadius = 10
        hardLevelButton.layer.shadowColor = UIColor.black.cgColor
        hardLevelButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        hardLevelButton.layer.shadowRadius = 1
        hardLevelButton.layer.shadowOpacity = 1.0
        hardLevelButton.tintColor = UIColor.black
        hardLevelButton.backgroundColor = customColor
        hardLevelButton.layer.shouldRasterize = true
        hardLevelButton.layer.rasterizationScale = UIScreen.main.scale
        hardLevelButton.tag = 3
        hardLevelButton.addTarget(self, action: #selector(levelButtonTapped), for: .touchUpInside)
        view.addSubview(hardLevelButton)
        
        extremeLevelButton.translatesAutoresizingMaskIntoConstraints = false
        extremeLevelButton.setTitle("Extreme", for: .normal)
        extremeLevelButton.titleLabel?.font = UIFont(name: "chalkduster", size: 30)
        extremeLevelButton.layer.cornerRadius = 10
        extremeLevelButton.layer.shadowColor = UIColor.black.cgColor
        extremeLevelButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        extremeLevelButton.layer.shadowRadius = 1
        extremeLevelButton.layer.shadowOpacity = 1.0
        extremeLevelButton.tintColor = UIColor.black
        extremeLevelButton.backgroundColor = customColor
        extremeLevelButton.layer.shouldRasterize = true
        extremeLevelButton.layer.rasterizationScale = UIScreen.main.scale
        extremeLevelButton.tag = 4
        extremeLevelButton.addTarget(self, action: #selector(levelButtonTapped), for: .touchUpInside)
        view.addSubview(extremeLevelButton)
        
        //borders:
        muteButton.layer.borderWidth = 2
        easyLevelButton.layer.borderWidth = 2
        normalLevelButton.layer.borderWidth = 2
        hardLevelButton.layer.borderWidth = 2
        extremeLevelButton.layer.borderWidth = 2
//        levelLabel.layer.borderWidth = 2
        
        //MARK: - constraints
        
        NSLayoutConstraint.activate([
            
            muteButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            muteButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            muteButton.heightAnchor.constraint(equalToConstant: 40),
            muteButton.widthAnchor.constraint(equalToConstant: 40),
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            levelLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 220),
            levelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            easyLevelButton.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 20),
            easyLevelButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            easyLevelButton.heightAnchor.constraint(equalToConstant: 70),
            easyLevelButton.widthAnchor.constraint(equalToConstant: 150),
            
            normalLevelButton.topAnchor.constraint(equalTo: easyLevelButton.bottomAnchor,constant: 20),
            normalLevelButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            normalLevelButton.heightAnchor.constraint(equalToConstant: 70),
            normalLevelButton.widthAnchor.constraint(equalToConstant: 150),
            
            hardLevelButton.topAnchor.constraint(equalTo: normalLevelButton.bottomAnchor,constant: 20),
            hardLevelButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            hardLevelButton.heightAnchor.constraint(equalToConstant: 70),
            hardLevelButton.widthAnchor.constraint(equalToConstant: 150),
            
            extremeLevelButton.topAnchor.constraint(equalTo: hardLevelButton.bottomAnchor,constant: 20),
            extremeLevelButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            extremeLevelButton.heightAnchor.constraint(equalToConstant: 70),
            extremeLevelButton.widthAnchor.constraint(equalToConstant: 150)
            
        ])
    }
    
    //MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        animationButton(easyLevelButton)
        animationButton(normalLevelButton)
        animationButton(hardLevelButton)
        animationButton(extremeLevelButton)
        
        try? audioFX.openFile(file: "background", type: "mp3")
    }
    
    //MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        animationButton(easyLevelButton)
        animationButton(normalLevelButton)
        animationButton(hardLevelButton)
        animationButton(extremeLevelButton)
        
        try? audioFX.openFile(file: "background", type: "mp3")
    }
    
    //MARK: - muteTapped()
    
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
    
    //MARK: - levelButtonTapped
    
    @objc func levelButtonTapped(_ sender: UIButton) {
        
        //AudioFX
        try? audioFX.openFile(file: "Magic", type: "wav")
        
        switch sender.tag {
        case 1:
            levelContent.difficultyLevel = 1
            difficultLevelLabel = 1
        case 2:
            levelContent.difficultyLevel = 2
            difficultLevelLabel = 2
        case 3:
            levelContent.difficultyLevel = 3
            difficultLevelLabel = 3
        case 4:
            levelContent.difficultyLevel = 4
            difficultLevelLabel = 4
        default:
            levelContent.difficultyLevel = 1
            difficultLevelLabel = 1
        }
        
        guard let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "GameView") as? ViewController else {
            print("Could not instantiate view controller with identifier of type SecondViewController")
            return
        }
        
        //taking results to ViewController
        vc.difficultLevelLabel = self.difficultLevelLabel
        vc.muteButton.isSelected = self.muteButton.isSelected
        vc.audioFX.muted = self.audioFX.muted
        vc.levelContent.difficultyLevel = self.levelContent.difficultyLevel
        
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //MARK: - animationButton
    
    func animationButton(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            UIView.animate(withDuration: 2.0,
                                       delay: 0,
                                       usingSpringWithDamping: CGFloat(0.5),
                                       initialSpringVelocity: CGFloat(0.5),
                                       options: UIView.AnimationOptions.allowUserInteraction,
                                       animations: {
                                        sender.transform = CGAffineTransform.identity
                },
                                       completion: { Void in()  }
            )
    }
    
}
