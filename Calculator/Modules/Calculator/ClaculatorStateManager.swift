//
//  ClaculatorStateManager.swift
//  Calculator
//
//  Created by Yousef on 4/22/21.
//

import Foundation

class ClaculatorStateManager {
    
    private var states: [CalculationState]
    private let statesAccessQueue: DispatchQueue
    private var lastUndoneStateIndex: Int
    var current: CalculationState {
        statesAccessQueue.sync {
            states.last!
        }
    }
    
    init() {
        states = [CalculationState(operations: [])]
        statesAccessQueue = DispatchQueue(label: "thread-safe-states-access", attributes: .concurrent)
        lastUndoneStateIndex = -1
    }
    
    /// Inserts new state to done operations
    /// - Parameter op: New done operation
    func newCalculation(_ op: MathOperation) {
        var lastState = current
        lastState.newOperation(op)
        
//        statesAccessQueue.async(flags: .barrier) {
//            self.states.append(lastState)
//        }
        
        makeWriteOperationOnStates {
            $0.append(lastState)
        }
        
        DispatchQueue.main.async {
            self.resetCounter()
        }
        
    }
    
    
    /// Undoes last done operation if possible and updates current state
    func undo() {
        guard canUndo() else { return }
        
        if lastUndoneStateIndex == -1 { lastUndoneStateIndex = states.endIndex - 1 }
        lastUndoneStateIndex -= 1
        
        var state = getState(atIndex: lastUndoneStateIndex)
        
        state.isCopy = true
        
        makeWriteOperationOnStates { states in
            states.append(state)
        }
        
    }
    
    
    /// Undones operation at given index by applying the reverse of it and updating current state
    /// - Parameter index: Index of operation to be undone
    func undo(operationAt index: Int) {
        guard index >= 0, index < states.count else { return }
        
        var state = current
        state.undoOperationAt(index: index)
        state.isCopy = true
        
        makeWriteOperationOnStates { states in
            states.append(state)
        }
        
        DispatchQueue.main.async {
            self.resetCounter()
        }
        
    }
    
    /// Redoes last undone operation if possible and update current state
    func redo() {
        guard canRedo() else {
            if getState(atIndex: lastUndoneStateIndex + 1).isCopy { resetCounter() }
            return
        }
        
        lastUndoneStateIndex += 1
        
        var state = getState(atIndex: lastUndoneStateIndex)
        
        state.isCopy = true
        
        makeWriteOperationOnStates { states in
            states.append(state)
        }
        
    }
    
    
    /// Checks if there is an undoable action
    /// - Returns: Boolean states if there is any undoables
    func canUndo()-> Bool {
        let index = lastUndoneStateIndex == -1 ? states.endIndex - 1 : lastUndoneStateIndex
        return index > 0
    }
    
    /// Checks if there is an redoable action
    /// - Returns: Boolean states if there is any redoables
    func canRedo()-> Bool {
        lastUndoneStateIndex != -1 &&
        lastUndoneStateIndex < (states.endIndex - 2) &&
        !getState(atIndex: lastUndoneStateIndex + 1).isCopy
    }
    
    /// Resets the counter to last index and assign all operations as non-copies
    private func resetCounter() {
        lastUndoneStateIndex = states.endIndex - 1
        makeWriteOperationOnStates {
            $0.resetCopies()
        }
//        statesAccessQueue.async(flags: .barrier) {
//            self.states.resetCopies()
//        }
    }
    
    /// Fires Given Block on specific Dispatch Queue to assure a thread safe access
    private func makeWriteOperationOnStates(_ block: @escaping (inout [CalculationState])-> Void) {
        statesAccessQueue.async(flags: .barrier) {
            block(&self.states)
        }
    }
    
    /// Gets state of specific index on specific Dispatch Queue to assure a thread safe access
    /// - Parameter index: Index of wanted state
    /// - Returns: CalculationState object at given index
    private func getState(atIndex index: Int)-> CalculationState {
        var state: CalculationState!
        statesAccessQueue.sync {
            state = states[index]
        }
        return state
    }
    
}
