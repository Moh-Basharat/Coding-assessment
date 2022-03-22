//
//  AcronymService.swift
//  Acronyms
//
//  Created by Mohammad on 22/03/22.
//

import Foundation

/// Abstraction for service class
protocol AcronymDataProvider {
    var response: AcronymServiceResponse? { get set }
    var error: Error? { get set }
    func fetchData(query: String) async
}

class AcronymService: AcronymDataProvider {
    var apiClient: APIClientProtocol?
    var isInprogress: Bool = false
    var response: AcronymServiceResponse?
    var error: Error?
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchData(query: String) async {
        guard !isInprogress else { return }
        isInprogress = true
        typealias SResult = Result<[AcronymServiceResponse], Error>
        let result: SResult? = try? await apiClient?.call(request: query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
        self.isInprogress = false
        guard let searchResult = result else {
            self.response = nil
            return
        }
        switch searchResult {
            case .success(let data):
                self.response = data.first
            case .failure(let error):
                self.error = error
                break
        }
    }
}
