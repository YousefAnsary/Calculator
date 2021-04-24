//
//  UITextField+.swift
//  Calculator
//
//  Created by Yousef on 4/24/21.
//

import UIKit

extension UITextField{
    
    @IBInspectable var doneAccessory: Bool{
        get {
            return self.doneAccessory
        }
        set {
            self.inputAccessoryView = newValue ? createDoneBtnToolbar() : nil
        }
    }

    func createDoneBtnToolbar()-> UIToolbar {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        return doneToolbar

//        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
}
