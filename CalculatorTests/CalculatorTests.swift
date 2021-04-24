//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Yousef on 4/20/21.
//

import XCTest
@testable import Calculator

class CurrencyConverterMocker: CurrencyConverterDelegate {
    
    private let expectation: XCTestExpectation
    private var amount: Double!
    
    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }
    
    func setAmount(_ amount: Double) {
        self.amount = amount
    }
    
    func conversion(successWithResult result: Double) {
        guard let ratio = UserDefaultsManager.shared.EGP_USDRatio else {
            XCTFail("No found ratios")
            return
        }
        let res = amount * ratio
        if result == res {
            expectation.fulfill()
        } else {
            XCTFail("Expected \(res) found \(result)")
        }
    }
    
    func conversion(failedWithError error: APIError) {
        XCTFail("Failed Conversion with error: \(error)")
    }
    
    func startLoading() {}
    
    func dismissLoader() {}
    
    func displayAlert(withMessage message: String) {}
    
}

class CurrencyConverterTest: XCTestCase {

    var suit: CurrencyConverterPresenter?
    var mocker: CurrencyConverterMocker?
    var myExpectaion: XCTestExpectation?
    
    override func setUpWithError() throws {
        myExpectaion = self.expectation(description: "Testing Currency Conversion")
        mocker = CurrencyConverterMocker(expectation: myExpectaion!)
        suit = CurrencyConverterPresenter(delegate: mocker!)
    }

    override func tearDownWithError() throws {
        suit = nil
        mocker = nil
        myExpectaion = nil
    }

    func testConversion() throws {
        let amount = "20"
        mocker?.setAmount(Double(amount)!)
        suit?.convert(amount: amount)
        wait(for: [myExpectaion!], timeout: 30)
    }

}
