//
//  CurrencyConverterVC.swift
//  Calculator
//
//  Created by Yousef on 4/21/21.
//

import UIKit

/// View Controller of Currency Converter Module
class CurrencyConverterVC: BaseViewController {

    //MARK: - Variables
    @IBOutlet private weak var egpTF: UITextField!
    @IBOutlet private weak var convertBtn: UIButton!
    @IBOutlet private weak var resultLbl: UILabel!
    var presenter: CurrencyConverterPresenter?
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        egpTF.text = presenter?.lastCalculation
        self.convertBtn.isEnabled = !egpTF.text!.isEmpty
    }
    
    //MARK: - Tap Handlers
    @IBAction private func convertBtnTapped(_ sender: UIButton) {
        resultLbl.text = "Loading..."
        presenter?.convert(amount: egpTF.text!)
    }

}

//MARK: - Private Functions
extension CurrencyConverterVC {
    
    private func configureViews() {
        resultLbl.text = ""
        egpTF.delegate = self
    }
    
}

//MARK: - Delegate
extension CurrencyConverterVC: CurrencyConverterDelegate {
    
    /// Called on successful Conversion is Made to update views
    /// - Parameter result: Result of conversion operation as Double
    func conversion(successWithResult result: Double) {
        resultLbl.text = "\(result.asFormattedString()) USD"
    }
    
    /// Called when conversion operation fails to handle the error
    /// - Parameter error: APIError object returned from service layer
    func conversion(failedWithError error: APIError) {
        resultLbl.text = ""
        self.handleError(error: error)
    }
    
}

//MARK: - UITextFieldDelegate
extension CurrencyConverterVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        convertBtn.isEnabled = !(textField.text!.count == 1 && string == "")
        return true
    }
    
}
