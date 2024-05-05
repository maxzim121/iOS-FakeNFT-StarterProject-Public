//
//  CartRequests.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 26.04.2024.
//

import Foundation

struct CartItemsRequest: NetworkRequest {
    let requestId = "CartItemsRequest"
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }
}

struct CartPutRequest: NetworkRequest {

    let requestId = "CartPutRequest"
    
    let id: Int
    let nfts: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var body: Data? {
        encodeNFTSList().data(using: .utf8)
    }
    
    private func encodeNFTSList() -> String {
        
        var nftsString = "id=\(self.id)"
    
        if !self.nfts.isEmpty {
            nftsString += "&nfts="
            nftsString += self.nfts.joined(separator: "&nfts=")
        }

        return nftsString
    }
}
