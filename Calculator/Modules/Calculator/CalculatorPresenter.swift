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
    func calculation(madeWithResult result: String)
}

class CalculatorPresenter {
    
    private weak var delegate: CalculatorDelegate?
    private let stateManager: ClaculatorStateManager
    var mediator: CurrencyCalculatorMediator?
    
    var lastOperation = MathOperation(operator: .add, firstOperand: 0, secondOperand: 0)
    
    var operationsCount: Int {
        stateManager.current.operations.count
    }
    
    init(delegate: CalculatorDelegate) {
        self.delegate = delegate
        stateManager = ClaculatorStateManager()
    }
    
    func calculate(firstOperand: Double, secondOperand: Double, operation: MathOperator) {
        
        if case MathOperator.divise = operation, secondOperand == 0 {
            delegate?.displayAlert(withMessage: "Can't divide by zero")
        }
        
        stateManager.newCalculation(MathOperation(operator: operation, firstOperand: firstOperand, secondOperand: secondOperand))
        
        fireDelegates()
        mediator?.notify(res: stateManager.current.finalResult.asFormattedString(), sender: self)
        
    }
    
    func textForItemAt(indexPath: IndexPath)-> String {
        guard indexPath.row < operationsCount else {
            fatalError("Index \(indexPath.row) Out Of Range \(operationsCount)")
        }
        let item = stateManager.current.operations[indexPath.row]
        return "\(item.operator.rawValue) \(item.secondOperand.asFormattedString())"
    }
    
    func undo() {
        stateManager.undo()
        fireDelegates()
        mediator?.notify(res: stateManager.current.finalResult.asFormattedString(), sender: self)
    }
    
    func redo() {
        stateManager.redo()
        fireDelegates()
        mediator?.notify(res: stateManager.current.finalResult.asFormattedString(), sender: self)
    }
    
    private func fireDelegates() {
        delegate?.updateUndoBtnState(to: stateManager.canUndo())
        delegate?.updateRedoBtnState(to: stateManager.canRedo())
        delegate?.reloadCollectionView()
        delegate?.calculation(madeWithResult: stateManager.current.finalResult.asFormattedString())
    }
    
}

extension CalculatorPresenter: CalculatorMediator {
    
    func currencyConversionMade(withResult res: String) {
        guard let res = Double(res) else {return}
        let finalRes = stateManager.current.finalResult
        let op: MathOperator = finalRes > res ? .substract : .add
        let diff = abs(finalRes - res)
        stateManager.newCalculation(MathOperation(operator: op, firstOperand: stateManager.current.finalResult, secondOperand: diff))
        fireDelegates()
    }
    
}
