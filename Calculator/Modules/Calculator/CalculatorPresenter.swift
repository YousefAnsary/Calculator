//
//  CalculatorVM.swift
//  Calculator
//
//  Created by Yousef on 4/20/21.
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

struct MathOperation {
    let `operator`: MathOperator
    let firstOperand: Double
    let secondOperand: Double
}

protocol CalculatorDelegate: Delegate {
    func updateUndoBtnState(to value: Bool)
    func updateRedoBtnState(to value: Bool)
    func reloadCollectionView()
    
}

class CalculatorPresenter {
    
    var selectedOperation: MathOperator?
    private var lastResult: Double = 0
    private weak var delegate: CalculatorDelegate?
    private var doneOperations = [MathOperation]()
    var operationsCount: Int {
        doneOperations.count
    }
    
    init(delegate: CalculatorDelegate) {
        self.delegate = delegate
    }
    
    func calculate(firstOperand: Double, secondOperand: Double, operation: MathOperator)-> String {
        
        var result: Double!
        
        switch operation {
        case .add:
            result = firstOperand + secondOperand
        case .substract:
            result = firstOperand - secondOperand
        case .multiply:
            result = firstOperand * secondOperand
        case .divise:
            guard secondOperand != 0 else {
                delegate?.displayAlert(withMessage: "Can't Divide By Zero!")
                return String(lastResult)
            }
            result = firstOperand / secondOperand
        }
        
        doneOperations.append(MathOperation(operator: operation, firstOperand: firstOperand, secondOperand: secondOperand))
        delegate?.reloadCollectionView()
        delegate?.updateUndoBtnState(to: true)
        lastResult = result
        return String(result)
    }
    
    func textForItemAt(indexPath: IndexPath)-> String {
        guard indexPath.row < operationsCount else {
            fatalError("Index \(indexPath.row) Out Of Range \(operationsCount)")
        }
        let item = doneOperations[indexPath.row]
        return "\(item.operator.rawValue) \(item.secondOperand)"
    }
    
    func undo()-> String {
        let operation = doneOperations.last!
        doneOperations.removeLast()
        if doneOperations.isEmpty {
            delegate?.updateUndoBtnState(to: false)
        }
        delegate?.reloadCollectionView()
        let res = operation.operator.oppositeOpertaion().calculate(number1: lastResult, number2: operation.secondOperand)
        lastResult = res
        return String(res)
    }
    
}
