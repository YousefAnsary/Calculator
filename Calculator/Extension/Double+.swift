//
//  Double+.swift
//  Calculator
//
//  Created by Yousef on 4/21/21.
//

import Foundation

extension Double {
    
    func asFormattedString(f: String = "0.4")-> String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(self) : String(format: "%\(f)f", self)
    }
    
}
