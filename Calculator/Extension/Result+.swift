//
//  Result+.swift
//  SMSTome.com
//
//  Created by Yousef on 4/13/21.
//

import Foundation

extension Result where Success == Data, Failure == APIError {
    
    func mappingData<T: Codable>(to type: T.Type)-> Result<T, Failure> {
        switch self {
        case .success(let data):
            do {
                return .success(try data.decode(toType: T.self))
            } catch(let err) {
                return .failure(APIError.decodingFailed(data: data, error: err))
            }
        case .failure(let err):
            return .failure(err)
        }
    }
    
    func mappingToDictionary()-> Result<[String: Any?]?, Failure> {
        switch self {
        case .success(let data):
            do {
                return .success(try data.toDictionary())
            } catch(let err) {
                return .failure(APIError.decodingFailed(data: data, error: err))
            }
        case .failure(let err):
            return .failure(err)
        }
    }
    
}
