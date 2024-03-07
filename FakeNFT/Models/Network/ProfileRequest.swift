//
// Created by Ruslan S. Shvetsov on 12.02.2024.
//

import Foundation

public struct ProfileRequest: Codable {
    var name: String
    var avatar: String
    var description: String
    var website: String
    var likes: [String]

    init(name: String, avatar: String, description: String, website: String, likes: [String]) {
        self.name = name
        self.avatar = avatar
        self.description = description
        self.website = website
        self.likes = likes
    }

    init(from profileModel: Profile) {
        name = profileModel.name
        avatar = profileModel.avatar.absoluteString
        description = profileModel.description
        website = profileModel.website.absoluteString
        likes = profileModel.likes
    }

    static func createWithDefaultValues() -> ProfileRequest? {
        guard let avatarURL = URL(string: UserProfileConstants.defaultAvatar),
              let websiteURL = URL(string: UserProfileConstants.defaultWebsite)
        else {
            return nil
        }

        return ProfileRequest(
                name: UserProfileConstants.defaultName,
                avatar: avatarURL.absoluteString,
                description: UserProfileConstants.defaultDescription,
                website: websiteURL.absoluteString,
                likes: UserProfileConstants.defaultLikes.components(separatedBy: ",")
        )
    }
}
