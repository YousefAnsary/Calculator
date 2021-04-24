//
//  Presenter.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import UIKit

protocol Delegate: class {
    
    func startLoading()
    func dismissLoader()
    func displayAlert(withMessage message: String)
    
}
