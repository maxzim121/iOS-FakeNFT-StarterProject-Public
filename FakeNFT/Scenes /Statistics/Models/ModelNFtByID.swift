//
//  ModelNFtByID.swift
//  FakeNFT
//
//  Created by Александр Медведев on 25.02.2024.
//

import Foundation

struct NftByIdServer: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}
