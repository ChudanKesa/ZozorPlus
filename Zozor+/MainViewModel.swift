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
    
    private var stringNumbers: [String] = [String()]
    private var isExpressionCorrect: Bool {
        if let stringNumber = stringNumbers.last {
            if stringNumber.isEmpty {
                if stringNumbers.count == 1 {
                    presentAlert(for: .newCalcul)
                } else {
                    presentAlert(for: .enterCorrectExpression)
                }
            }
        }
        return true
    }
    
    private var carAddOperator: Bool {
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
        _displayedText = Operands.zero.rawValue
    }
    
    // MARK: - Helper
    
    private func presentAlert(for alertType: AlertType) {
        let configuration = AlertConfiguration(alertType: alertType)
        navigateToScreen?(.alert(alertConfiguration: configuration))
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

