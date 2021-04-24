//
//  File.swift
//  Calculator
//
//  Created by Yousef on 4/22/21.
//

import Foundation

struct CalculationState {
    
    private(set) var operations: [MathOperation]
    private var undoneOperations: [(index: Int, operation: MathOperation)]
    var isCopy = false
    
    init(operations: [MathOperation]) {
        self.operations = operations
        undoneOperations = []
    }
    
    var finalResult: Double {
        if operations.isEmpty && !undoneOperations.isEmpty {
            let total = undoneOperations.reduce(0) { (res, op) -> Double in
                op.operation.operator.calculate(number1: res, number2: op.operation.secondOperand)
            }
            return undoneOperations.reduce(total) { (res, op) -> Double in
                op.operation.operator.reversed().calculate(number1: res, number2: op.operation.secondOperand)
            }
        }
        let total = operations.reduce(operations.first?.firstOperand ?? 0) { res, op-> Double in
            op.operator.calculate(number1: res, number2: op.secondOperand)
        }
        return undoneOperations.reduce(total) { (res, op) -> Double in
            op.operation.operator.reversed().calculate(number1: res, number2: op.operation.secondOperand)
        }
    }
    
    /// Undoes operation at given index by applying the reverse of it
    /// - Parameter index: Integer index of operation to be undone
    mutating func undoOperationAt(index: Int) {
        let op = operations[index]
        undoneOperations.append((index: index, operation: op))
        operations.remove(at: index)
    }
    
    /// Inserts new operation
    /// - Parameter operation: MathOperation to be inserted
    mutating func newOperation(_ operation: MathOperation) {
        operations.append(operation)
    }
    
}

extension Array where Element == CalculationState {
    
    /// Assigns all elements isCopy attribue to false
    mutating func resetCopies() {
        for i in self.startIndex ..< self.endIndex {
            self[i].isCopy = false
        }
    }
    
}

