//
//  CalculatorVM.swift
//  Calculator
//
//  Created by Yousef on 4/20/21.
//

import Foundation

protocol CalculatorDelegate: Delegate {
    func updateUndoBtnState(to value: Bool)
    func updateRedoBtnState(to value: Bool)
    func reloadCollectionView()
    func calculation(MadeWithResult result: String)
}

class CalculatorPresenter {
    
    var selectedOperation: MathOperator?
    var undoManager = UndoManager()
    private(set) var lastResult: Double = 0
    private weak var delegate: CalculatorDelegate?
    private var operations = [MathOperation]()
    private var doneOperations = [MathOperation]() {
        didSet {
            delegate?.reloadCollectionView()
//            delegate?.updateUndoBtnState(to: !doneOperations.isEmpty)
        }
    }
    private var redoOperations = [MathOperation]() {
        didSet {
//            delegate?.updateRedoBtnState(to: !redoOperations.isEmpty)
        }
    }
    
    var lastOperation = MathOperation(operator: .add, firstOperand: 0, secondOperand: 0)
    
    var operationsCount: Int {
        operations.count
    }
    
    init(delegate: CalculatorDelegate) {
        self.delegate = delegate
    }
    
    func calculate(firstOperand: Double, secondOperand: Double, operation: MathOperator) {//-> String {
        
        if case MathOperator.divise = operation, secondOperand == 0 {
            delegate?.displayAlert(withMessage: "Can't divide by zero")
//            return lastResult.asFormattedString()
        }
        
//        let oldOperation = lastOperation
//        lastOperation = MathOperation(operator: operation, firstOperand: firstOperand, secondOperand: secondOperand)
        storeOperation(MathOperation(operator: operation, firstOperand: firstOperand, secondOperand: secondOperand))
        
        let result = operation.calculate(number1: firstOperand, number2: secondOperand)
        
        doneOperations.append(MathOperation(operator: operation, firstOperand: firstOperand, secondOperand: secondOperand))
        
//        undoManager.registerUndo(withTarget: self) { targetSelf in
////            self.
//        }
        
        delegate?.reloadCollectionView()
        lastResult = result
        redoOperations.removeAll()
//        delegate?.calculation(MadeWithResult: result.asFormattedString())
//        return result.asFormattedString()
    }
    
    @objc func storeOperation(_ operation: Any) {
        let oldOperation = lastOperation
        lastOperation = operation as! MathOperation
        self.undoManager.registerUndo(withTarget: self, selector: #selector(self.storeOperation(_:)), object: oldOperation)
        DispatchQueue.main.async { [self] in
            delegate?.calculation(MadeWithResult: lastOperation.result.asFormattedString())
            delegate?.updateUndoBtnState(to: undoManager.canUndo)
            delegate?.updateRedoBtnState(to: undoManager.canRedo)
        }
    }
    
    func textForItemAt(indexPath: IndexPath)-> String {
        guard indexPath.row < operationsCount else {
            fatalError("Index \(indexPath.row) Out Of Range \(operationsCount)")
        }
        let item = doneOperations[indexPath.row]
        return "\(item.operator.rawValue) \(item.secondOperand.asFormattedString())"
    }
    
    func undo() { //}-> String {
        if undoManager.canUndo {
            undoManager.undo()
        }
//        let operation = doneOperations.last!
//        redoOperations.append(operation)
//        doneOperations.removeLast()
//        delegate?.reloadCollectionView()
//        let res = operation.operator.oppositeOpertaion().calculate(number1: lastResult, number2: operation.secondOperand)
//        lastResult = res
//        return res.asFormattedString()
    }
    
    func redo() {//-> String {
        if undoManager.canRedo {
            undoManager.redo()
        }
//        let operation = redoOperations.last!
//        doneOperations.append(operation)
//        redoOperations.removeLast()
//        let res = operation.operator.calculate(number1: lastResult, number2: operation.secondOperand)
//        lastResult = res
//        return res.asFormattedString()
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
