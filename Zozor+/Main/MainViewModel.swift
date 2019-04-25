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
    
    private var computedText = Operands.zero.rawValue {
        didSet {
            displayedText?(computedText)
        }
    }
    
    private var wasTotalJustCalculated = false
    private var stringNumbers = [""]
    private var operatorsUsedDuringCalcul: [Operator] = [.plus]
    private var lastOperatorUsedDuringCalcul = Operator.plus
    private var lastOperandUsedDuringCalcul = ""
    
    private var isExpressionCorrect: Bool {
        if let stringNumber = stringNumbers.last {
            if operatorsUsedDuringCalcul.count == 1 {
                presentAlert(for: .enterCorrectExpression)
            }
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
    
    func didPressOperator(at index: Int) {
        guard index < operators.count else {
            return
        }
        
        let currentOperator = operators[index]
        
        if currentOperator != .minus {
            if !canAddOperator {
                return
            }
        }
        
        if currentOperator == .equal {
            if wasTotalJustCalculated {
                repeatTheLastOperation()
                return
            } else {
                calculateTotal()
            }
        } else {
            if wasTotalJustCalculated {
                if let result = stringNumbers.last {
                    computedText = result
                }
            }
            
            wasTotalJustCalculated = false
            updateDisplayedText(with: currentOperator.rawValue)
            stringNumbers.append("")
            operatorsUsedDuringCalcul.append(currentOperator)
        }
    }
    
    func didPressOperand(at index: Int) {
        guard index < operands.count else {
            return
        }
        
        if wasTotalJustCalculated {
            clear()
        }
        
        wasTotalJustCalculated = false
        addNewNumberToStringNumber(newNumber: operands[index].rawValue)
        updateDisplayedText(with: operands[index].rawValue)
        
    }
    
    func clear() {
        computedText = Operands.zero.rawValue
        clearTheReccordedOpperandsAndOpperatorsAndLastUsed()
    }
    
    // MARK: - Helper
    
    private func presentAlert(for alertType: AlertType) {
        let configuration = AlertConfiguration(alertType: alertType)
        navigateToScreen?(.alert(alertConfiguration: configuration))
    }
    
    private func initTexts() {
        displayedText?(computedText)
    }
    
    private func calculateTotal() {
        if !isExpressionCorrect {
            return
        }
        
        var total = 0
        lastOperatorUsedDuringCalcul = operatorsUsedDuringCalcul[operatorsUsedDuringCalcul.count-1]
        lastOperandUsedDuringCalcul = stringNumbers[stringNumbers.count-1]
        for (i, stringNumber) in stringNumbers.enumerated() {
            let currentOperator = operatorsUsedDuringCalcul[i]
            if let number = Int(stringNumber) {
                switch currentOperator {
                case .plus:
                    total += number
                case .minus:
                    total -= number
                case .times:
                    total *= number
                case .divided:
                    if number != 0 {
                        total /= number
                        } else {
                            presentAlert(for: .dividedByZero)
                            lastOperandUsedDuringCalcul = Operands.zero.rawValue
                            lastOperatorUsedDuringCalcul = .plus
                    }
                default:
                    break
                }
            }
        }
        
        computedText =  "\(total)"
        if operatorsUsedDuringCalcul.count > 1 { wasTotalJustCalculated = true }
        operatorsUsedDuringCalcul = [.plus]
        stringNumbers = [String(total)]
    }
    
    private func repeatTheLastOperation() {
        if lastOperandUsedDuringCalcul != "" {
            stringNumbers.append(lastOperandUsedDuringCalcul)
            operatorsUsedDuringCalcul.append(lastOperatorUsedDuringCalcul)
        }
        calculateTotal()
    }
    
    private func addNewNumberToStringNumber(newNumber : String) {
        if let stringNumber = stringNumbers.last {
            var stringNumberMutable = stringNumber
            stringNumberMutable += "\(newNumber)"
            stringNumbers[stringNumbers.count-1] = stringNumberMutable
        }
    }
    
    private func updateDisplayedText(with value: String) {
        if computedText == Operands.zero.rawValue {
            computedText = value
        } else {
            computedText += value
        }
    }
    
    private func clearTheReccordedOpperandsAndOpperatorsAndLastUsed() {
        operatorsUsedDuringCalcul = [.plus]
        stringNumbers = [""]
        lastOperandUsedDuringCalcul = ""
        lastOperatorUsedDuringCalcul = .plus
    }
}

fileprivate enum AlertType {
    case newCalcul
    case enterCorrectExpression
    case incorrectExpression
    case dividedByZero
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
        case .dividedByZero:
            self.message = "On ne peut pas diviser par zéro !"
        }
    }
}

extension MainViewModel.NextScreen: Equatable {
    static func ==(lhs: MainViewModel.NextScreen, rhs: MainViewModel.NextScreen) -> Bool {
        switch (lhs, rhs) {
        case let (.alert(c1), .alert(c2)):
            return c1 == c2
        }
    }
}
