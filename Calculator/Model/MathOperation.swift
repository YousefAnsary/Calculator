//
//  MathOperation.swift
//  Calculator
//
//  Created by Yousef on 4/22/21.
//

import Foundation

struct MathOperation {
    let `operator`: MathOperator
    let firstOperand: Double
    let secondOperand: Double
//    var isSelectivelyUndone = false
    var result: Double {
        self.operator.calculate(number1: firstOperand, number2: secondOperand)
    }
}
