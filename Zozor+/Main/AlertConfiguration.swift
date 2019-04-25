//
//  AlertConfiguration.swift
//  CountOnMe
//
//  Created by Erwan Le Querré on 25/04/2019.
//  Copyright © 2019 Ambroise Collon. All rights reserved.
//

import Foundation

struct AlertConfiguration {
    let title: String
    let message: String
    let actionTitle: String
}

extension AlertConfiguration: Equatable {
    static func ==(lhs: AlertConfiguration, rhs: AlertConfiguration) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}
