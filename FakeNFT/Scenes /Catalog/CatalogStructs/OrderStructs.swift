//
//  OrderStructs.swift
//  FakeNFT
//
//  Created by Maksim Zimens on 05.03.2024.
//

struct OrderNetworkModel: Codable {
    let nfts: [String]
    let id: String
}

struct OrderResultModel {
    let nfts: [String]
    let id: String
}
