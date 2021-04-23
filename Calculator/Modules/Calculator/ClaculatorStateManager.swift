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
    private var selectedUndoneIndex: Int?
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
    
    func newCalculation(_ op: MathOperation) {
//        state(atIndex: states.endIndex)
//        var lastState: CalculationState!
//        statesAccessQueue.sync {
//            lastState = states.last!
//        }
        
        var lastState = states.last! //current
        
        lastState.newOperation(op)
        states.append(lastState)
        
//        makeWriteOperationOnStates { states in
//            states.append(lastState)
//        }
        
//        statesAccessQueue.async(flags: .barrier) {
//            self.states.append(lastState)
//        }
        
        resetCounter()
    }
    
    func undo() {
        guard canUndo() else { return }
        if lastUndoneStateIndex == -1 { lastUndoneStateIndex = states.endIndex - 1 }
        lastUndoneStateIndex -= 1
        var state = states[lastUndoneStateIndex]// getState(atIndex: lastUndoneStateIndex)
//        var state: CalculationState!
//        statesAccessQueue.sync {
//            state = states[lastUndoneStateIndex]
//        }
        
        state.isCopy = true
        self.states.append(state)
//        makeWriteOperationOnStates { states in
//            states.append(state)
//        }
//        statesAccessQueue.async(flags: .barrier) {
//            self.states.append(state)
//        }
    }
    
    func undo(operationAt index: Int) {
//        let index = index - 1
        guard index >= 0, index < states.count else { return }
        var state = current
        state.undoOperationAt(index: index)
        state.isCopy = true
        makeWriteOperationOnStates { states in
            states.append(state)
        }
//        statesAccessQueue.async(flags: .barrier) {
//            self.states.append(state)
//        }
        resetCounter()
    }
    
    func redo() {
        guard canRedo() else {
            if getState(atIndex: lastUndoneStateIndex + 1).isCopy { resetCounter() }
            return
        }
        lastUndoneStateIndex += 1
        
        var state = getState(atIndex: lastUndoneStateIndex)//: CalculationState!
//        statesAccessQueue.sync {
//            state = states[lastUndoneStateIndex]
//        }
        state.isCopy = true
        makeWriteOperationOnStates { states in
            states.append(state)
        }
//        statesAccessQueue.async(flags: .barrier) {
//            self.states.append(state)
//        }
    }
    
    func canUndo()-> Bool {
        let index = lastUndoneStateIndex == -1 ? states.endIndex - 1 : lastUndoneStateIndex
        return index > 0
    }
    
    func canRedo()-> Bool {
        lastUndoneStateIndex != -1 &&
        lastUndoneStateIndex < (states.endIndex - 2) &&
        !getState(atIndex: lastUndoneStateIndex + 1).isCopy
    }
    
    private func resetCounter() {
        lastUndoneStateIndex = states.endIndex - 1
        statesAccessQueue.async(flags: .barrier) {
            self.states.resetCopies()
        }
    }
    
    private func makeWriteOperationOnStates(_ block: @escaping (inout [CalculationState])-> Void) {
        statesAccessQueue.async(flags: .barrier) {
            block(&self.states)
        }
    }
    
    private func getState(atIndex index: Int)-> CalculationState {
        var state: CalculationState!
        statesAccessQueue.sync {
            state = states[index]
        }
        return state
    }
    
}
