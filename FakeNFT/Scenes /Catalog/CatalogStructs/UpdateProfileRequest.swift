//
// Created by Ruslan S. Shvetsov on 13.02.2024.
//

import Foundation

struct UpdateProfileRequest: NetworkRequest {
    let id: String
    var profileData: ProfileRequest

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }

    var httpMethod: HttpMethod {
        .put
    }

    var dto: Encodable?

    init(id: String, profileData: ProfileRequest) {
        self.id = id
        self.profileData = profileData

        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "name", value: profileData.name),
            URLQueryItem(name: "avatar", value: profileData.avatar),
            URLQueryItem(name: "description", value: profileData.description),
            URLQueryItem(name: "website", value: profileData.website)
        ] + profileData.likes.map {
            URLQueryItem(name: "likes", value: $0)
        }

        if let queryString = components.percentEncodedQuery {
            dto = queryString
        }
    }
}
