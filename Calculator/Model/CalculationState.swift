//
//  File.swift
//  Calculator
//
//  Created by Yousef on 4/22/21.
//

import Foundation

struct CalculationState {
    
    var operations: [MathOperation]
    var finalResult: Double {
        operations.last?.result ?? 0
    }
    
    init(operations: [MathOperation]) {
        self.operations = operations
    }
    
}
