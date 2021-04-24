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
    
    /// Decodes given data object to given type
    /// - Parameters:
    ///   - data: Data object to decode
    ///   - type: Decodable type to decode to
    /// - Throws: throws decoding error if any
    /// - Returns: Decoded Object of given type
    func decode<T: Decodable>(_ data: Data, to type: T.Type) throws -> T {
        return try decoder.decode(type, from: data)
    }
    
    /// Returns Dictionary form given data object
    /// - Parameter data: Data object to decode
    /// - Throws: throws decoding error if any
    /// - Returns: Return decoded dictionary
    func dictionary(fromData data: Data)throws -> [String: Any] {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
    }
    
}
