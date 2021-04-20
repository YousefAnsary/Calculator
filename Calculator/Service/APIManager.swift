//
//  API.swift
//  GithubClient
//
//  Created by Yousef on 4/7/21.
//

import Foundation

class APIManager {
    
    private let baseURL: String
    static let shared = APIManager()
    
    private init() {
        guard let path = Bundle.main.path(forResource: "API", ofType: "plist"),
              let myDict = NSDictionary(contentsOfFile: path),
              let baseUrl = myDict.object(forKey: "BaseURL") as? String else {
                fatalError("BaseURL not found in API.plist")
        }
        self.baseURL = baseUrl
    }
    
    func get(fromURL urlString: String, params: [String: String]? = nil, completion: @escaping(Result<Data, APIError>)-> Void) {
        DispatchQueue.global(qos: .background).async {
            
            guard var urlComponents = URLComponents(string: urlString) else {
                DispatchQueue.main.async{ completion(.failure(APIError.invalidURL(url: urlString))) }
                return
            }
            
            urlComponents.query = self.queryString(fromDict: params)
            
            guard let url = urlComponents.url else {
                DispatchQueue.main.async{ completion(.failure(APIError.invalidURL(url: urlString))) }
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, res, err in
                guard err == nil, data != nil, 200...299 ~= (res?.statusCode() ?? 0) else {
                    DispatchQueue.main.async{
                        completion(.failure(APIError(rawValue: (res?.statusCode() ?? 0), data: data, error: err)))
                    }
                    return
                }
                DispatchQueue.main.async{ completion(.success(data!)) }
            }.resume()
        }
    }
    
    func get<T: Codable>(path: String, params: [String: String]? = nil, mappingTo type: T.Type, completion: @escaping(Result<T, APIError>)-> Void) {
        get(fromURL: baseURL + path, params: params) {
            switch $0.mappingData(to: T.self) {
            case .success(let mappedData):
                completion(.success(mappedData))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    private func queryString(fromDict dict: [String: Any]?)-> String? {
        return dict?.map { key, val in "\(key)=\(val)" }.joined(separator: "&")
    }
    
}
