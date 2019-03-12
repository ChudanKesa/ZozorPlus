//
//  MainSource.swift
//  CountOnMe
//
//  Created by Erwan Le Querré on 07/03/2019.
//  Copyright © 2019 Ambroise Collon. All rights reserved.
//

import Foundation

final class MainSource {
    
    let operators: [Operator]
    let operands: [Operands]
    
    init() {
        operators = [
            .plus,
            .minus,
            .equal
        ]
        
        operands = [
            .zero,
            .one,
            .two,
            .three,
            .four,
            .five,
            .six,
            .seven,
            .eight,
            .nine
        ]
    }
}
