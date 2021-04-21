//
//  CurrencyConvertService.swift
//  Calculator
//
//  Created by Yousef on 4/21/21.
//

import Foundation

class CurrencyConvertService {
    
    private init() {}
    
    class func EGP_USDRatio(completion: @escaping (Result<[String: Any?]?, APIError>)-> Void) {
        let params = ["q": "EGP_USD", "compact": "ultra", "apiKey": "1bd5e0ceb2ef267dd828"]
        APIManager.shared.get(fromURL: "https://free.currconv.com/api/v7/convert", params: params) { res in
            completion(res.mappingToDictionary())
        }
    }
    
}
