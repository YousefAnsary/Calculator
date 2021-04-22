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
    var current: CalculationState {
        states.last!
    }
    
    init() {
        states = [CalculationState(operations: [])]
        lastUndoneStateIndex = -1
    }
    
    func undo() {
        guard canUndo() else { return }
        if lastUndoneStateIndex == -1 { lastUndoneStateIndex = states.endIndex - 1 }
        lastUndoneStateIndex -= 1
        states.append(states[lastUndoneStateIndex])
    }
    
    func redo() {
        guard canRedo() else { return }
        lastUndoneStateIndex += 1
        states.append(states[lastUndoneStateIndex])
    }
    
    func newCalculation(_ state: MathOperation) {
        var lastState = states.last!
        lastState.operations.append(state)
        states.append(lastState)
        lastUndoneStateIndex = states.endIndex - 1
    }
    
    func canUndo()-> Bool {
        let index = lastUndoneStateIndex == -1 ? states.endIndex - 1 : lastUndoneStateIndex
        return index > 0
    }
    
    func canRedo()-> Bool {
        lastUndoneStateIndex != -1 && lastUndoneStateIndex < (states.endIndex - 2)
    }
    
}
