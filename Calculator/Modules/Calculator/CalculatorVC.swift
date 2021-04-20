//
//  ViewController.swift
//  Calculator
//
//  Created by Yousef on 4/20/21.
//

import UIKit

class CalculatorVC: BaseViewController {

    @IBOutlet private weak var resultLbl: UILabel!
    @IBOutlet private weak var secondOperandTF: UITextField!
    @IBOutlet private weak var undoBtn: UIButton!
    @IBOutlet private weak var plusBtn: UIButton!
    @IBOutlet private weak var minusBtn: UIButton!
    @IBOutlet private weak var multiplyBtn: UIButton!
    @IBOutlet private weak var diviseBtn: UIButton!
    @IBOutlet private weak var equalBtn: UIButton!
    @IBOutlet private weak var redoBtn: UIButton!
    @IBOutlet private weak var operationsCollectionView: UICollectionView!
    
    var presenter: CalculatorPresenter?
    private var operatorBtns: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        operationsCollectionView.register(MathOperationCollectionCell.self)
        secondOperandTF.delegate = self
        operationsCollectionView.delegate = self
        operationsCollectionView.dataSource = self
        
        operatorBtns = [plusBtn, minusBtn, multiplyBtn, diviseBtn]
    }

    @IBAction private func undoBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction private func plusBtnTapped(_ sender: UIButton) {
        operatorBtnTapped(sender)
    }
    
    @IBAction private func minusBtnTapped(_ sender: UIButton) {
        operatorBtnTapped(sender)
    }
    
    @IBAction private func multiplyBtnTapped(_ sender: UIButton) {
        operatorBtnTapped(sender)
    }
    
    @IBAction private func diviseBtnTapped(_ sender: UIButton) {
        operatorBtnTapped(sender)
    }
    
    @IBAction private func equalBtnTapped(_ sender: UIButton) {
        guard let selectedBtn = operatorBtns.first(where: { $0.isSelected }),
              let firstOperand = Double(resultLbl.text!),
              let secondOperand = Double(secondOperandTF.text!) else {return}
        
        var selectedOperator: MathOperator!
        switch (selectedBtn) {
        case plusBtn:
            selectedOperator = .add
        case minusBtn:
            selectedOperator = .substract
        case multiplyBtn:
            selectedOperator = .multiply
        case diviseBtn:
            selectedOperator = .divise
        default:
            return
        }
        resultLbl.text = presenter?.calculate(firstOperand: firstOperand, secondOperand: secondOperand, operation: selectedOperator)
        operatorBtns.forEach{$0.isSelected = false}
        secondOperandTF.text = ""
        equalBtn.isEnabled = false
    }
    
    @IBAction private func redoBtnTapped(_ sender: UIButton) {
        
    }
    
    private func operatorBtnTapped(_ sender: UIButton) {
        operatorBtns.filter{$0 != sender}.forEach{$0.isSelected = false}
        sender.isSelected.toggle()
        equalBtn.isEnabled = !secondOperandTF.text!.isEmpty && sender.isSelected
    }
    
}

extension CalculatorVC: CalculatorDelegate {
    
    func reloadCollectionView() {
        operationsCollectionView.reloadData()
    }
    
    func updateUndoBtnState(to value: Bool) {
        undoBtn.isEnabled = value
    }
    
    func updateRedoBtnState(to value: Bool) {
        redoBtn.isEnabled = value
    }
    
}

extension CalculatorVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.operationsCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MathOperationCollectionCell = collectionView.dequeue(indexPath: indexPath)
        cell.operationLbl.text = presenter?.textForItemAt(indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = presenter?.textForItemAt(indexPath: indexPath)
        label.sizeToFit()
        return CGSize(width: label.frame.width + 16, height: 50)
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
    
}

extension CalculatorVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.count == 1 && string == "" {
            equalBtn.isEnabled = false
            return true
        }
        let isOperationSelected = operatorBtns.contains(where: {$0.isSelected})
        equalBtn.isEnabled = isOperationSelected && ( !string.isEmpty || !textField.text!.isEmpty )
        return true
    }
    
}
