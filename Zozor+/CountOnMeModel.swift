//
//  CountOnMeModel.swift
//  CountOnMe
//
//  Created by Erwan Le Querré on 10/01/2019.
//  Copyright © 2019 Ambroise Collon. All rights reserved.
//

import Foundation

enum Operand {
    case plus
    case minus
    
    var stringValue: String {
        switch self {
        case .plus:
            return "+"
        case .minus:
            return "-"
        }
    }
}

final class MainSource {
    
    let operands: [Operand]
    
    init() {
        operands = [
            .plus,
            .minus
        ]
    }
}

final class MainViewModel {
    
    // MARK: - Private properties
    
    let operands: [Operand]
    
    
    // MARK: - Initializer
    
    init(source: MainSource) {
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
        displayedText?("")
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
    
    func didPressNumber(at index: Int) {
        
    }
    
    func didPressOperand(at index: Int) {
        guard index < operands.count else {
            fatalError()
        }
        
        displayedText?(operands[index].stringValue)
    }
}


