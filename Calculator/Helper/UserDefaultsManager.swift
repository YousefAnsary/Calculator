//
//  UserDefaultsManager.swift
//  Calculator
//
//  Created by Yousef on 4/21/21.
//

import Foundation

class UserDefaultsManager {
    
    private init() {}
    
    private let EGP_USDRatioKey = "com.calculator.egp_usd"
    
    private let userDefaults = UserDefaults.standard
    
    static let shared = UserDefaultsManager()
    
    /// Saved Ratio of EGP to USD currencies if any
    var EGP_USDRatio: Double? {
        get {
            return userDefaults.double(forKey: EGP_USDRatioKey)
        } set {
            userDefaults.set(newValue, forKey: EGP_USDRatioKey)
        }
    }
    
}
