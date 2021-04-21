//
//  AppCoordinator.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import UIKit

class AppCoordinator {
    
    private let window: UIWindow
    private var tabBarController: UITabBarController
    
    init(window: UIWindow) {
        self.window = window
        tabBarController = UITabBarController()
    }
    
    func start() {
        let calculatorVC = CalculatorVC(nibName: "CalculatorView", bundle: nil)
        let calculatorPresenter = CalculatorPresenter(delegate: calculatorVC)
        calculatorVC.presenter = calculatorPresenter
        
        let currencyConverterVC = CurrencyConverterVC(nibName: "CurrencyConverterView", bundle: nil)
        let currencyConverterPresenter = CurrencyConverterPresenter(delegate: currencyConverterVC)
        currencyConverterVC.presenter = currencyConverterPresenter
        
        let mediator = CurrencyCalculatorMediator(component1: calculatorVC, component2: currencyConverterVC)
        calculatorVC.mediator = mediator
        currencyConverterVC.mediator = mediator
        
        tabBarController.addChild(calculatorVC)
        tabBarController.addChild(currencyConverterVC)
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
//        tabBarController.tabBar.items?[0].title = "Calculator"
        tabBarController.tabBar.items?[0].image = UIImage(named: "calc")
//        tabBarController.tabBar.items?[1].title = "Currency Converter"
        tabBarController.tabBar.items?[1].image = UIImage(named: "dollar")
    }
    
}
