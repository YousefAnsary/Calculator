//
//  Array+UIButton.swift
//  Calculator
//
//  Created by Yousef on 4/20/21.
//

import UIKit

extension Array where Element == UIButton {
    
    func deselectAll() {
        self.forEach{ $0.isSelected = false }
    }
    
}
