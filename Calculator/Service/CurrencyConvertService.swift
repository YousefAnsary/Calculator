//
//  CurrencyConvertService.swift
//  Calculator
//
//  Created by Yousef on 4/21/21.
//

import Foundation

class CurrencyConvertService {
    
    private init() {}
    
    /// Gets saved ratio of EGP to USD Currencies if any or Hits API to get the ratio
    /// - Parameter completion: Result Type of Dictionary, APIError fired whenever the request is complete
    class func EGP_USDRatio(refreshRatioRemotely: Bool = false, completion: @escaping (Result<Double, APIError>)-> Void) {
        
        if let ratio = UserDefaultsManager.shared.EGP_USDRatio, !refreshRatioRemotely {
            completion(.success(ratio))
            return
        }
        
        let params = ["q": "EGP_USD", "compact": "ultra", "apiKey": "1bd5e0ceb2ef267dd828"]
        APIManager.shared.get(fromURL: "https://free.currconv.com/api/v7/convert", params: params) { res in
            
            let res = res.flatMap { data -> Result<Double, APIError> in
                do {
                    let dict = try data.toDictionary()
                    guard let ratio = dict?["EGP_USD"] as? Double else {
                        return .failure(.unknown(statusCode: 0, data: nil, error: nil))
                    }
                    return .success(ratio)
                } catch {
                    return .failure(.decodingFailed(data: data, error: error))
                }
            }
            
            completion(res)
            
        }
        
    }
    
}
