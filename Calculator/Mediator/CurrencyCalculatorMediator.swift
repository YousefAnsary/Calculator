//
//  CurrencyCalculatorMediator.swift
//  Calculator
//
//  Created by Yousef on 4/21/21.
//

import Foundation

protocol Mediator: class {}

protocol CurrencyConverterMediator: Mediator {
    func caculationMade(withResult res: String)
}

protocol CalculatorMediator: Mediator {
    func currencyConversionMade(withResult res: String)
}

class CurrencyCalculatorMediator {
    
    private weak var component1: CalculatorMediator?
    private weak var component2: CurrencyConverterMediator?
    
    init(component1: CalculatorMediator, component2: CurrencyConverterMediator) {
        self.component1 = component1
        self.component2 = component2
    }
    
    func notify(res: String, sender: Mediator) {
        switch sender {
        case is CalculatorMediator:
            component2?.caculationMade(withResult: res)
        case is CurrencyConverterMediator:
            component1?.currencyConversionMade(withResult: res)
        default:
            return
        }
    }
    
}
