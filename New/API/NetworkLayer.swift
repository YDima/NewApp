//
//  NetworkLayer.swift
//  New
//
//  Created by Dmytro Yurchenko on 22.03.2023.
//

import Foundation

fileprivate let apiKey = "fFxMlWdLg6FXQPcXsAMfgxhkQ4ObIMQH"

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case incorrectPath
    case badResponse
}

protocol Request {
    associatedtype Response: Decodable
    
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

protocol Network {
    func sendRequest<T: Request>(_ request: T, completion: @escaping (Result<T.Response, Error>) -> Void)
}

class NetworkLayer: Network {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func sendRequest<T: Request>(_ request: T, completion: @escaping (Result<T.Response, Error>) -> Void) {
        guard let url = URL(string: request.path) else {
            return completion(.failure(NetworkError.incorrectPath))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        if let parameters = request.parameters {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.Response.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
