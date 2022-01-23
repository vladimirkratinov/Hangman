//
//  levelContent.swift
//  hangman
//
//  Created by Vladimir Kratinov on 2022/1/19.
//

import UIKit

let customColor = UIColor(red: 0.10, green: 0.74, blue: 0.61, alpha: 1.00)

class HighlightedButtonGreen: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .green : customColor
        }
    }
}

class HighlightedButtonYellow: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .yellow : customColor
        }
    }
}

class HighlightedButtonRed: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .red : . orange
        }
    }
}

class HighlightedButtonOrange: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .orange : customColor
        }
    }
}

class HighlightedButtonBlue: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .blue : customColor
        }
    }
}

//MARK: - Level Buttons MENU:

class EasyLevelButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .green : customColor
        }
    }
}

class NormalLevelButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .blue : customColor
        }
    }
}

class HardLevelButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .orange : customColor
        }
    }
}

class ExtremeLevelButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .red : customColor
        }
    }
}

//MARK: - MuteButton

class MuteButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .red : .orange
        }
    }
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? . red : .orange
        }
    }
}




