//
//  File.swift
//  Calculator
//
//  Created by Yousef on 4/22/21.
//

import Foundation

struct CalculationState {
    
    var operations: [MathOperation]
    var selectedUndoneOperations = [MathOperation]()
    private var _finalRes: Double?
    var finalResult: Double {
        get {
            return _finalRes != nil ? _finalRes! : operations.last?.result ?? 0
        } set {
            _finalRes = newValue
        }
    }
    
    init(operations: [MathOperation]) {
        self.operations = operations
    }
    
}
