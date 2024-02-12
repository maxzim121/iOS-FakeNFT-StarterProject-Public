//
// Created by Ruslan S. Shvetsov on 12.02.2024.
//

import Foundation

public struct ProfileResponse: Codable {
    var name: String
    var avatar: URL
    var description: String
    var website: URL
    var nfts: [String]
    var likes: [String]
    var id: String
}
