//
//  ViewController.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    
    func displayAlert(withMessage message: String, title: String? = nil, btnHandler: ((UIAlertAction)-> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: btnHandler))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            
        }
        
    }
    
    func dismissLoader() {
        DispatchQueue.main.async {
            
        }
    }
    
    /// Handles errors by calling the specified method as demanded per project
    func handleError(error: Error) {
        
        guard let apiError = error as? APIError else {
            unexpectedError()
            return
        }
        
        switch apiError {
        case .unAuthenticated(_):
            unexpectedError()
        case .unAuthorized(_):
            unexpectedError()
        case .notFound(_):
            unexpectedError()
        case .methodNotAllowed(_):
            unexpectedError()
        case .internalServerError(_):
            unexpectedError()
        case .unknown(_, _, _):
            unexpectedError()
        case .decodingFailed(_, _):
            unexpectedError()
        case .invalidURL(_):
            unexpectedError()
        }
    
    }
    
    func unexpectedError() {
        displayAlert(withMessage: "Unexpected error, please try again.")
    }
    
}
