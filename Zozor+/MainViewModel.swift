//
//  CountOnMeModel.swift
//  CountOnMe
//
//  Created by Erwan Le Querré on 10/01/2019.
//  Copyright © 2019 Ambroise Collon. All rights reserved.
//

import Foundation

struct AlertConfiguration {
    let title: String
    let message: String
    let actionTitle: String
}

final class MainViewModel {
    
    // MARK: - Private properties
    
    private let operators: [Operator]
    
    private let operands: [Operands]
    
    private var _displayedText = Operands.zero.rawValue {
        didSet {
            displayedText?(_displayedText)
        }
    }
    
    private var wasTotalCalculated = false
    private var stringNumbers: [String] = [String()]
    private var operatorsUsedDuringCalcul: [String] = ["+"]
    private var isExpressionCorrect: Bool {
        if let stringNumber = stringNumbers.last {
            if stringNumber.isEmpty {
                if stringNumbers.count == 1 {
                    presentAlert(for: .newCalcul)
                } else {
                    presentAlert(for: .enterCorrectExpression)
                }
                return false
            }
        }
        return true
    }
    
    private var canAddOperator: Bool {
        if let stringNumber = stringNumbers.last {
            if stringNumber.isEmpty {
                presentAlert(for: .incorrectExpression)
                return false
            }
        }
        return true
    }
    
    // MARK: - Initializer
    
    init(source: MainSource) {
        self.operators = source.operators
        self.operands = source.operands
    }
    
    // MARK: - Properties
    
    enum NextScreen {
        case alert(alertConfiguration: AlertConfiguration)
    }
    
    // MARK: - Outputs
    
    var displayedText: ((String) -> Void)?
    var navigateToScreen: ((NextScreen) -> Void)?
    
    
    // MARK: - Inputs
    
    func viewDidLoad() {
        initTexts()
    }
    
    private func initTexts() {
        displayedText?(_displayedText)
    }
    
    func didPressOperator(at index: Int) {
        guard index < operators.count else {
            return
        }
        
        if !canAddOperator {
            return
        }
        
        if index == 2 {
            calculateTotal()
            return
        }
        
        if wasTotalCalculated {
            if let result = stringNumbers.last {
                _displayedText = result
            }
        }
        
        wasTotalCalculated = false
        
        let currentOpperator = operators[index].rawValue
        
        updateDisplayedText(with: currentOpperator)
        stringNumbers.append("")
        operatorsUsedDuringCalcul.append(currentOpperator)
    }
    
    func didPressOperand(at index: Int) {
        guard index < operands.count else {
            return
        }
        
        if wasTotalCalculated {
            clear()
        }
        
        wasTotalCalculated = false
        addNewNumberToStringNumber(newNumber: operands[index].rawValue)
        updateDisplayedText(with: operands[index].rawValue)
        
    }
    
    private func addNewNumberToStringNumber(newNumber : String) {
        if let stringNumber = stringNumbers.last {
            var stringNumberMutable = stringNumber
            stringNumberMutable += "\(newNumber)"
            stringNumbers[stringNumbers.count-1] = stringNumberMutable
        }
    }
    
    func updateDisplayedText(with value: String) {
        if _displayedText == "0" {
            _displayedText = value
        } else {
            _displayedText += value
        }
    }
    
    func clear() {
        _displayedText = Operands.zero.rawValue
        clearTheReccordedOpperandsAndOpperators()
    }
    
    // MARK: - Helper
    
    private func presentAlert(for alertType: AlertType) {
        let configuration = AlertConfiguration(alertType: alertType)
        navigateToScreen?(.alert(alertConfiguration: configuration))
    }
    
    private func calculateTotal() {
        if !isExpressionCorrect {
            return
        }
        
        var total = 0
        for (i, stringNumber) in stringNumbers.enumerated() {
            if let number = Int(stringNumber) {
                if operatorsUsedDuringCalcul[i] == "+" {
                    total += number
                } else if operatorsUsedDuringCalcul[i] == "-" {
                    total -= number
                }
            }
        }
        
        _displayedText = _displayedText + "=\n\(total)"
        operatorsUsedDuringCalcul = ["+"]
        stringNumbers = [String(total)]
        wasTotalCalculated = true
    }
    
    private func clearTheReccordedOpperandsAndOpperators() {
        operatorsUsedDuringCalcul = ["+"]
        stringNumbers = [String()]
    }
}


fileprivate enum AlertType {
    case newCalcul
    case enterCorrectExpression
    case incorrectExpression
}

fileprivate extension AlertConfiguration {
    init(alertType: AlertType) {
        self.title = "Zéro!"
        self.actionTitle = "OK"
        switch alertType {
        case .enterCorrectExpression:
            self.message = "Entrez une expression correcte !"
        case .incorrectExpression:
            self.message = "Expression incorrecte !"
        case .newCalcul:
            self.message = "Démarrez un nouveau calcul !"
        }
    }
}

