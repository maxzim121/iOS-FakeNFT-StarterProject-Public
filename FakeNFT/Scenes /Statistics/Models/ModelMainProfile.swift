//
//  ModelMainProfile.swift
//  FakeNFT
//
//  Created by Александр Медведев on 26.02.2024.
//

import Foundation

struct MainProfile: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
