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
//    var undoManager = UndoManager()
    private(set) var lastResult: Double = 0
    private weak var delegate: CalculatorDelegate?
    private var doneOperations = [MathOperation]() {
        didSet {
            delegate?.reloadCollectionView()
            delegate?.updateUndoBtnState(to: !doneOperations.isEmpty)
        }
    }
    private var redoOperations = [MathOperation]() {
        didSet {
            delegate?.updateRedoBtnState(to: !redoOperations.isEmpty)
        }
    }
    
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
        lastResult = result
        redoOperations.removeAll()
        return result.asFormattedString()
    }
    
    func textForItemAt(indexPath: IndexPath)-> String {
        guard indexPath.row < operationsCount else {
            fatalError("Index \(indexPath.row) Out Of Range \(operationsCount)")
        }
        let item = doneOperations[indexPath.row]
        return "\(item.operator.rawValue) \(item.secondOperand.asFormattedString())"
    }
    
    func undo()-> String {
        
        let operation = doneOperations.last!
        redoOperations.append(operation)
        doneOperations.removeLast()
        delegate?.reloadCollectionView()
        let res = operation.operator.oppositeOpertaion().calculate(number1: lastResult, number2: operation.secondOperand)
        lastResult = res
        return res.asFormattedString()
    }
    
    func redo()-> String {
        let operation = redoOperations.last!
        doneOperations.append(operation)
        redoOperations.removeLast()
        let res = operation.operator.calculate(number1: lastResult, number2: operation.secondOperand)
        lastResult = res
        return res.asFormattedString()
    }
    
    func currencyConversionMade(withResult res: String) {
        guard let res = Double(res) else {return}
        let _operator: MathOperator = lastResult > res ? .substract : .add
        let mathOperation = MathOperation(operator: _operator, firstOperand: lastResult, secondOperand: abs(lastResult - res))
        doneOperations.append(mathOperation)
        delegate?.reloadCollectionView()
        lastResult = res
    }
    
}
