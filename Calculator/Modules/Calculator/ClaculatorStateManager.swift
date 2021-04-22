//
//  ClaculatorStateManager.swift
//  Calculator
//
//  Created by Yousef on 4/22/21.
//

import Foundation

class ClaculatorStateManager {
    
    private var states: [CalculationState]
    private var lastUndoneStateIndex: Int
    private var selectedUndoneIndex: Int?
    var current: CalculationState {
        states.last!
    }
    
    init() {
        states = [CalculationState(operations: [])]
        lastUndoneStateIndex = -1
    }
    
    func newCalculation(_ state: MathOperation) {
        var lastState = states.last!
        lastState.operations.append(state)
        states.append(lastState)
        lastUndoneStateIndex = states.endIndex - 1
    }
    
    func undo() {
        guard canUndo() else { return }
        if lastUndoneStateIndex == -1 { lastUndoneStateIndex = states.endIndex - 1 }
        lastUndoneStateIndex -= 1
        states.append(states[lastUndoneStateIndex])
    }
    
    func undo(operationAt index: Int) {
//        let index = index - 1
        guard index >= 0, index < states.count else { return }
        var state = current //states[index]
//        state.selectedUndoneOperations.append(state.operations[index])
        state.finalResult = state.operations[index].operator.oppositeOpertaion().calculate(number1: state.finalResult, number2: state.operations[index].secondOperand)
        state.operations.remove(at: index)
        states.append(state)
        lastUndoneStateIndex = states.endIndex - 1
    }
    
    func redo() {
        guard canRedo() else { return }
        lastUndoneStateIndex += 1
        states.append(states[lastUndoneStateIndex])
    }
    
    func canUndo()-> Bool {
        let index = lastUndoneStateIndex == -1 ? states.endIndex - 1 : lastUndoneStateIndex
        return index > 0
    }
    
    func canRedo()-> Bool {
        lastUndoneStateIndex != -1 && lastUndoneStateIndex < (states.endIndex - 2)
    }
    
}
