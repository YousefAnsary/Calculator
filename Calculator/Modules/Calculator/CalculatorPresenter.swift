//
//  CalculatorVM.swift
//  Calculator
//
//  Created by Yousef on 4/20/21.
//

import Foundation

protocol CalculatorDelegate: Delegate {
    /// Called to update isEnabled property of undo btn
    /// - Parameter value: Bool indicates if there is any undoables
    func updateUndoBtnState(to value: Bool)
    /// Called to update isEnabled property of redo btn
    /// - Parameter value: Bool indicates if there is any redoables
    func updateRedoBtnState(to value: Bool)
    /// Called to update operations shown in the CollectionView
    func reloadCollectionView()
    /// Called to delegate the result of last operation
    func calculation(madeWithResult result: String)
}

class CalculatorPresenter {
    
    private weak var delegate: CalculatorDelegate?
    private let stateManager: ClaculatorStateManager
    var mediator: CurrencyCalculatorMediator?
    
    var operationsCount: Int {
        stateManager.current.operations.count
    }
    
    init(delegate: CalculatorDelegate) {
        self.delegate = delegate
        stateManager = ClaculatorStateManager()
    }
    
    
    /// Makes given math operation, stores it to undo history and delegates result
    /// - Parameters:
    ///   - firstOperand: First operand in the math equation
    ///   - secondOperand: First operand in the math equation
    ///   - operation: Operator Type
    func calculate(firstOperand: Double, secondOperand: Double, operation: MathOperator) {
        
        if case MathOperator.divise = operation, secondOperand == 0 {
            delegate?.displayAlert(withMessage: "Can't divide by zero")
            return
        }
        
        stateManager.newCalculation(MathOperation(operator: operation, firstOperand: firstOperand, secondOperand: secondOperand))
        
        fireDelegates()
        
    }
    
    /// Returns formatted string describing operation at given index
    /// - Parameter indexPath: Index of requird operation
    /// - Returns: Operation described as String like `+5`
    func textForItemAt(indexPath: IndexPath)-> String {
        guard indexPath.row < operationsCount else {
            fatalError("Index \(indexPath.row) Out Of Range \(operationsCount)")
        }
        let item = stateManager.current.operations[indexPath.row]
        return "\(item.operator.rawValue) \(item.secondOperand.asFormattedString())"
    }
    
    /// Called to undo operation at given index
    /// - Parameter index: IndexPath of tapped cell to undo its operation
    func cellTapped(AtIndex index: IndexPath) {
        stateManager.undo(operationAt: index.row)
        fireDelegates()
    }
    
    /// Undoes last done operation if possible and delegates result
    func undo() {
        stateManager.undo()
        fireDelegates()
    }
    
    /// Redoes last undone operation if possible and delegates result
    func redo() {
        stateManager.redo()
        fireDelegates()
    }
    
    private func fireDelegates() {
        delegate?.updateUndoBtnState(to: stateManager.canUndo())
        delegate?.updateRedoBtnState(to: stateManager.canRedo())
        delegate?.reloadCollectionView()
        delegate?.calculation(madeWithResult: stateManager.current.finalResult.asFormattedString())
        mediator?.notify(res: stateManager.current.finalResult.asFormattedString(), sender: self)
    }
    
}


//MARK: - Mediator
extension CalculatorPresenter: CalculatorMediator {
    
    func currencyConversionMade(fromGivenAmount amount: String) {
        guard let amount = Double(amount) else {return}
        let finalRes = stateManager.current.finalResult
        let op: MathOperator = finalRes > amount ? .substract : .add
        let diff = abs(finalRes - amount)
        stateManager.newCalculation(MathOperation(operator: op, firstOperand: stateManager.current.finalResult, secondOperand: diff))
        fireDelegates()
    }
    
}
