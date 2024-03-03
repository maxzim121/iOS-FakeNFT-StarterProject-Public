//
// Created by Ruslan S. Shvetsov on 12.02.2024.
//

import Foundation

public struct Profile: Codable, Equatable {
    let name: String
    let avatar: URL
    let description: String
    let website: URL
    let nfts: [String]
    let likes: [String]
    let id: String

    init(from responseModel: ProfileResponse) {
        name = responseModel.name
        avatar = responseModel.avatar
        description = responseModel.description
        website = responseModel.website
        nfts = responseModel.nfts
        likes = responseModel.likes
        id = responseModel.id
    }

    init(name: String, avatar: URL, description: String, website: URL, nfts: [String], likes: [String], id: String) {
        self.name = name
        self.avatar = avatar
        self.description = description
        self.website = website
        self.nfts = nfts
        self.likes = likes
        self.id = id
    }

    static var standard: Profile {
        Profile(
                name: UserProfileConstants.defaultName,
                avatar: URL(string: UserProfileConstants.defaultAvatar)!,
                description: UserProfileConstants.defaultDescription,
                website: URL(string: UserProfileConstants.defaultWebsite)!,
                nfts: UserProfileConstants.defaultNFTs.split(separator: ",").map(String.init),
                likes: UserProfileConstants.defaultLikes.split(separator: ",").map(String.init),
                id: UserProfileConstants.defaultID
        )
    }
}
