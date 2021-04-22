//
//  MathOperator.swift
//  Calculator
//
//  Created by Yousef on 4/22/21.
//

import Foundation

enum MathOperator: String {
    case add = "+"
    case substract = "-"
    case multiply = "*"
    case divise = "/"
    
    func oppositeOpertaion()-> MathOperator {
        switch self {
        case .add:
            return .substract
        case .substract:
            return .add
        case .multiply:
            return.divise
        case .divise:
            return .multiply
        }
    }
    
    func calculate(number1: Double, number2: Double)-> Double {
        switch self {
        case .add:
            return number1 + number2
        case .substract:
            return number1 - number2
        case .multiply:
            return number1 * number2
        case .divise:
            guard number2 != 0 else { fatalError("Can't Divide By zero") }
            return number1 / number2
        }
    }
    
}
