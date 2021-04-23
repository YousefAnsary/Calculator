//
//  CurrencyConverterPresenter.swift
//  Calculator
//
//  Created by Yousef on 4/21/21.
//

import Foundation

/// Delegate of Currency Converter Module
protocol CurrencyConverterDelegate: Delegate {
    /// Called on succes conversions
    /// - Parameter result: Result of conversion operation as Double
    func conversion(successWithResult result: Double)
    /// Called on failed conversions
    /// - Parameter error: APIError object returned from service layer
    func conversion(failedWithError error: APIError)
}

/// Presenter of Currency Converter Module
class CurrencyConverterPresenter {
    
    private weak var delegate: CurrencyConverterDelegate?
    var mediator: CurrencyCalculatorMediator?
    private(set) var lastCalculation: String?
    
    init(delegate: CurrencyConverterDelegate) {
        self.delegate = delegate
    }
    
    /// Converts given amount of EGPs to USD and delegates it
    /// - Parameter amount: amount to be converted from EGP to USD
    func convert(amount: String) {
        
        guard let amount = Double(amount) else {return}
        
        CurrencyConvertService.EGP_USDRatio { [weak self] res in
            guard let self = self else {return}
            switch res {
            case .success(let dict):
                guard let ratio = dict?["EGP_USD"] as? Double else { self.convertFailed(withError: nil, forAmount: amount); return }
                UserDefaultsManager.shared.EGP_USDRatio = ratio
                self.delegate?.conversion(successWithResult: ratio * amount)
                self.mediator?.notify(res: String(amount), sender: self)
            case .failure(let err):
                self.convertFailed(withError: err, forAmount: amount)
            }
        }
        
    }
    
    /// Called if failed to fetch ratio from API to convert using local saved ratio if any
    /// - Parameters:
    ///   - error: APIError object Returned from service layer
    ///   - amount: Given amount to convert using local saved ratio if any
    private func convertFailed(withError error: APIError?, forAmount amount: Double) {
        guard let ratio = UserDefaultsManager.shared.EGP_USDRatio else {
            delegate?.conversion(failedWithError: error ?? .unknown(statusCode: 0, data: nil, error: nil))
            return
        }
        delegate?.conversion(successWithResult: ratio * amount)
        mediator?.notify(res: String(amount), sender: self)
    }
    
}

// MARK: - Mediator
extension CurrencyConverterPresenter: CurrencyConverterMediator {
    
    /// Called whenever calculator makes a new operation to store it to be used as currency input
    func caculationMade(withResult res: String) {
        lastCalculation = res
    }
    
}
