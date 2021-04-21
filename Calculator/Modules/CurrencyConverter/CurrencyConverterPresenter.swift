//
//  CurrencyConverterPresenter.swift
//  Calculator
//
//  Created by Yousef on 4/21/21.
//

import Foundation

protocol CurrencyConverterDelegate: Delegate {
    func conversion(successWithResult result: Double)
    func conversion(failedWithError error: APIError)
}

class CurrencyConverterPresenter {
    
    private weak var delegate: CurrencyConverterDelegate?
    private(set) var lastCalculation: String?
    
    init(delegate: CurrencyConverterDelegate) {
        self.delegate = delegate
    }
    
    func convert(amount: String) {
        
        guard let amount = Double(amount) else {return}
        
        CurrencyConvertService.EGP_USDRatio { [weak self] res in
            switch res {
            case .success(let dict):
                guard let ratio = dict?["EGP_USD"] as? Double else { self?.convertFailed(withError: nil, forAmount: amount); return }
                UserDefaultsManager.shared.EGP_USDRatio = ratio
                self?.delegate?.conversion(successWithResult: ratio * amount)
            case .failure(let err):
                self?.convertFailed(withError: err, forAmount: amount)
            }
        }
        
    }
    
    private func convertFailed(withError error: APIError?, forAmount amount: Double) {
        guard let ratio = UserDefaultsManager.shared.EGP_USDRatio else {
            delegate?.conversion(failedWithError: error ?? .unknown(statusCode: 0, data: nil, error: nil))
            return
        }
        delegate?.conversion(successWithResult: ratio * amount)
    }
    
    func storeLastCalculation(_ res: String) {
        lastCalculation = res
    }
    
}