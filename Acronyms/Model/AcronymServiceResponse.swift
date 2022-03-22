//
//  AcronymServiceResponse.swift
//  Acronyms
//
//  Created by Mohammad on 22/03/22.
//

import Foundation

struct AcronymServiceResponse: Decodable {
    let results: [Result]
    let acronym: String
    
    enum CodingKeys: String, CodingKey {
        case results = "lfs"
        case acronym = "sf"
    }
    
    struct Result: Decodable {
        let longForm: String
        
        enum CodingKeys: String, CodingKey {
            case longForm = "lf"
        }
    }
}

