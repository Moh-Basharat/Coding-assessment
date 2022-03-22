//
//  APIClient.swift
//  LoginScreenArchitecure
//
//  Created by Mohammad on 22/03/22.
//

import Foundation

protocol APIClientProtocol {
    func call<R: Encodable, T: Decodable>(request: R) async throws -> Result<T, Error>
}

class APIClient {
    private let networkConfig: NetworkConfigProtocol
    
    init(networkConfig: NetworkConfigProtocol = NetworkConfig(path: "", method: "")) {
        self.networkConfig = networkConfig
    }
}

extension APIClient: APIClientProtocol {
    func call<R: Encodable, T: Decodable>(request: R) async throws -> Result<T, Error> {
        let requestData = try? JSONEncoder().encode(request)
        let urlString: String
        if self.networkConfig.isQuery, let request = request as? String {
            urlString = self.networkConfig.urlString + request
        } else {
            urlString = self.networkConfig.urlString
        }
        guard let url = URL(string: urlString) else {
            return .failure(APIError.invalidResponse)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = networkConfig.method
        if networkConfig.method == "POST" {
            urlRequest.httpBody = requestData
        }
        
        return try await withCheckedThrowingContinuation({ continuation in
            guard let data = try? Data.init(contentsOf: url, options: Data.ReadingOptions.alwaysMapped) else {
                return
            }
            guard let model = try? JSONDecoder().decode(T.self, from: data) else {
                continuation.resume(returning: .failure(APIError.notReachable))
                return
            }
            continuation.resume(returning: .success(model))
        })
    }
}

protocol NetworkConfigProtocol {
    var baseURL: String { get }
    var path: String? { get }
    var method: String { get }
    var isQuery: Bool { get set }
    var apiKey: String { get }
}

extension NetworkConfigProtocol {
    var urlString: String {
        return baseURL + (path ?? "")
    }
}

struct NetworkConfig: NetworkConfigProtocol {
    let apiKey = "somekey"
    var isQuery = true
    var baseURL: String = "http://www.nactem.ac.uk/software/acromine/dictionary.py?"
    var path: String?
    var method: String = "GET"
    
    init(path: String, method: String = "GET", isQuery: Bool = true) {
        self.path = path
        self.method = method
        self.isQuery = isQuery
    }
}

enum APIError: Error {
    case invalidResponse
    case notReachable
    
    var errorDescription: String {
        switch self {
            case .invalidResponse:
                return "Something went wrong"
            case .notReachable:
                return "Server is down"
        }
    }
}


public enum HTTPMethodType : String {
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
    public init(type :String?) {
        
        if let type = type {
        
            self = HTTPMethodType(rawValue: type) ?? .get
        } else {
            self = .get
        }
        
    }
}

public enum HTTPHeaderField {
    
    static let contentType = "Content-Type"
}

public enum ContentType {
    
    static let applicationJson = "application/json"
}
