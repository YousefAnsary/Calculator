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
//        calculatorPresenter.delegate =
//        calculatorVC.mediator =
//        calculatorVC.presenter =
//        let currentConverterVC = CalculatorVC(nibName: "CurrentConverterView", bundle: nil)
//        let currentConverterPresenter = CurrentConverterPresenter
//        currentConverterPresenter.delegate =
//        currentConverterVC.mediator =
//        currentConverterVC.presenter =
        tabBarController.addChild(calculatorVC)
//        tabBarController.addChild(currentConverterVC)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
}
