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
        let currencyConverterVC = CurrencyConverterVC(nibName: "CurrencyConverterView", bundle: nil)
        
        let calculatorPresenter = CalculatorPresenter(delegate: calculatorVC)
        let currencyConverterPresenter = CurrencyConverterPresenter(delegate: currencyConverterVC)
        
        let mediator = CurrencyCalculatorMediator(component1: calculatorPresenter, component2: currencyConverterPresenter)
        
        calculatorVC.presenter = calculatorPresenter
        currencyConverterVC.presenter = currencyConverterPresenter
        
        calculatorPresenter.mediator = mediator
        currencyConverterPresenter.mediator = mediator
        
        tabBarController.addChild(calculatorVC)
        tabBarController.addChild(currencyConverterVC)
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        tabBarController.tabBar.items?[0].image = UIImage(named: "calc")
        tabBarController.tabBar.items?[1].image = UIImage(named: "dollar")
    }
    
}
