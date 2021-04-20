//
//  JSONHelper.swift
//  GithubClient
//
//  Created by Yousef on 4/8/21.
//

import Foundation

class JSONHelper {
    
    static let shared = JSONHelper()
    private let decoder: JSONDecoder
    
    private init() {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        dateFormatter.isLenient = false
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        self.decoder = decoder
    }
    
    func decode<T: Decodable>(_ data: Data, to type: T.Type) throws -> T {
        return try decoder.decode(type, from: data)
    }
    
    func dictionary(fromData data: Data)throws -> [String: Any] {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
    }
    
}
