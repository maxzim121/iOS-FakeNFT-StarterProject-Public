//
//  ModelOrder.swift
//  FakeNFT
//
//  Created by Александр Медведев on 28.02.2024.
//

import Foundation

struct Order: Codable {
    let nfts: [String]
    let id: String
}
