//
//  Data+Decodable.swift
//  SMSTome.com
//
//  Created by Yousef on 4/13/21.
//

import Foundation

extension Data {
    
    func decode<T: Decodable>(toType type: T.Type) throws-> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
    
}
