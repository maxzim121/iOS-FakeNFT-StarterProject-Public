//
//  Models.swift
//  FakeNFT
//
//  Created by Александр Медведев on 18.02.2024.
//

import Foundation

struct UserProfile: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
