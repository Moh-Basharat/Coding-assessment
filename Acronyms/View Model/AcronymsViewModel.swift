//
//  AcronymsViewModel.swift
//  Acronyms
//
//  Created by Mohammad on 22/03/22.
//

import Foundation
import UIKit

class AcronymsViewModel: AcronymsDesignable {
    private(set) var acronyms: [String] = []
    private let service: AcronymDataProvider
    
    var searchText: String? {
        didSet {
            self.fetchData()
        }
    }
    
    var screenTitle: String { "Acronyms" }
    
    var searchPlacehoder: String { "Type to search" }
    
    init(service: AcronymDataProvider = AcronymService()) {
        self.service = service
    }
    
    private func fetchData() {
        guard let text = self.searchText, text.count > 1 else { return }
        Task {
            await service.fetchData(query: "sf=\(text)")
            if let acronyms =  service.response?.results.compactMap({ $0.longForm }) {
                self.acronyms = acronyms
                DispatchQueue.main.async {
                    self.bindingObject?.reloadData()
                }
            } else {
                self.bindingObject?.showDisplayError(message: "No response from api")
            }
        }
    }
    
    weak var bindingObject: BindableObject?
    
    func bind(withObject objet: BindableObject?) {
        self.bindingObject = objet
    }
}
