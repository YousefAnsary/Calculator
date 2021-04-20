//
//  APIError.swift
//  SMSTome.com
//
//  Created by Yousef on 4/13/21.
//

import Foundation

enum APIError: Error {
    case unAuthenticated(data: Data?)
    case unAuthorized(data: Data?)
    case notFound(data: Data?)
    case methodNotAllowed(data: Data?)
    case internalServerError(data: Data?)
    case unknown(statusCode: Int, data: Data?, error: Error?)
    case decodingFailed(data: Data?, error: Error?)
    case invalidURL(url: String)
    
    init(rawValue: Int, data: Data?, error: Error?) {
        switch rawValue {
        case 401:
            self = .unAuthenticated(data: data)
        case 403:
            self = .unAuthorized(data: data)
        case 404:
            self = .notFound(data: data)
        case 405:
            self = .methodNotAllowed(data: data)
        case 500:
            self = .internalServerError(data: data)
        default:
            self = .unknown(statusCode: rawValue, data: data, error: error)
        }
    }
    
}
