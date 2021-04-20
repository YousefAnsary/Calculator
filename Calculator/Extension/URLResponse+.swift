//
//  URLResponse.swift
//  SMSTome.com
//
//  Created by Yousef on 4/13/21.
//

import Foundation

extension URLResponse {
    
    func statusCode()-> Int? {
        (self as? HTTPURLResponse)?.statusCode
    }
    
}
