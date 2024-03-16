//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Maksim Zimens on 05.03.2024.
//

import Foundation

struct OrderRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }
}

struct OrderPutRequest: NetworkRequest {
    let id: String
    var nfts: [String]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }

    var httpMethod = HttpMethod.put
    var dto: Encodable?
    init(id: String, nfts: [String]) {
        self.id = "1"
        self.nfts = nfts

        var components = URLComponents()
        components.queryItems = nfts.map {
            URLQueryItem(name: "nfts", value: $0)
        }

        if let queryString = components.percentEncodedQuery {
            dto = queryString
        }
    }

}
