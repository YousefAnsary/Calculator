//
//  CurrencyCalculatorMediator.swift
//  Calculator
//
//  Created by Yousef on 4/21/21.
//

import Foundation

protocol Mediator: class {}

/// Delegate Protocol to get notified on calculation is made
protocol CurrencyConverterMediator: Mediator {
    /// Called whenever calculator makes a new calculation
    /// - Parameter res: Result of the calculation formatted as String
    func caculationMade(withResult res: String)
}

/// Delegate Protocol to get notified on curreny conversion is made
protocol CalculatorMediator: Mediator {
    /// Called whenever currency converter makes a successful conversion
    /// - Parameter amount: Amount user typed in EGP to convert from
    func currencyConversionMade(fromGivenAmount amount: String)
}

/// Mediator to notify CalculatorMediator, CurrencyConverterMediator of data changes
class CurrencyCalculatorMediator {
    
    private weak var component1: CalculatorMediator?
    private weak var component2: CurrencyConverterMediator?
    
    init(component1: CalculatorMediator, component2: CurrencyConverterMediator) {
        self.component1 = component1
        self.component2 = component2
    }
    
    
    /// Notifies other receivers in the mediator of given event
    /// - Parameters:
    ///   - res: Event to be published
    ///   - sender: Sender Mediator to notify the other components
    func notify(res: String, sender: Mediator) {
        switch sender {
        case is CalculatorMediator:
            component2?.caculationMade(withResult: res)
        case is CurrencyConverterMediator:
            component1?.currencyConversionMade(fromGivenAmount: res)
        default:
            return
        }
    }
    
}
