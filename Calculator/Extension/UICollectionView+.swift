//
//  UICollectionView+.swift
//  Calculator
//
//  Created by Yousef on 4/20/21.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        let name = String(describing: T.self)
        let nib = UINib(nibName: name, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: name)
    }
    
    func dequeue<T: UICollectionViewCell>(indexPath: IndexPath)-> T {
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
    
}
