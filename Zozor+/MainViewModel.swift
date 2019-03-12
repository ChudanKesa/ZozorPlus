//
//  CountOnMeModel.swift
//  CountOnMe
//
//  Created by Erwan Le Querré on 10/01/2019.
//  Copyright © 2019 Ambroise Collon. All rights reserved.
//

import Foundation

final class MainViewModel {
    
    // MARK: - Private properties
    
    private let operators: [Operator]
    
    private let operands: [Operands]
    
    private var _displayedText = "0" {
        didSet {
            displayedText?(_displayedText)
        }
    }
    
    // MARK: - Initializer
    
    init(source: MainSource) {
        self.operators = source.operators
        self.operands = source.operands
    }
    
    // MARK: - Outputs
    
    var displayedText: ((String) -> Void)?
    
    var plusText: ((String) -> Void)?
    
    var minusText: ((String) -> Void)?
    
    var equalsText: ((String) -> Void)?
    
    var oneText: ((String) -> Void)?
    
    var twoText: ((String) -> Void)?
    
    var threeText: ((String) -> Void)?
    
    var fourText: ((String) -> Void)?
    
    var fiveText: ((String) -> Void)?
    
    var sixText: ((String) -> Void)?
    
    var sevenText: ((String) -> Void)?
    
    var eightText: ((String) -> Void)?
    
    var nineText: ((String) -> Void)?
    
    var zeroText: ((String) -> Void)?
    
    
    // MARK: - Inputs
    
    func viewDidLoad() {
        initTexts()
    }
    
    private func initTexts() {
        displayedText?(_displayedText)
        plusText?("+")
        minusText?("-")
        equalsText?("=")
        oneText?("1")
        twoText?("2")
        threeText?("3")
        fourText?("4")
        fiveText?("5")
        sixText?("6")
        sevenText?("7")
        eightText?("8")
        nineText?("9")
        zeroText?("0")
    }
    
    func didPressOperator(at index: Int) {
        guard index < operators.count else {
            fatalError()
        }
        
        if _displayedText.last! != "+" && _displayedText.last! != "-" && _displayedText != "0" {
            updateDisplayedText(with: operators[index].rawValue)
        }
    }
    
    func didPressOperand(at index: Int) {
        guard index < operands.count else {
            fatalError()
        }
        
        updateDisplayedText(with: operands[index].rawValue)
    }
    
    func updateDisplayedText(with value: String) {
        if _displayedText == "0" {
            _displayedText = value
        } else {
            _displayedText += value
        }
    }
    
    func clear() {
        _displayedText = "0"
    }
    
}


