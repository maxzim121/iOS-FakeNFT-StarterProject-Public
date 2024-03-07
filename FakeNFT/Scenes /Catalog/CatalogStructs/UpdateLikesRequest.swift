//
// Created by Ruslan S. Shvetsov on 24.02.2024.
//

import Foundation

struct UpdateLikesRequest: NetworkRequest {
    let id: String
    var likes: [String]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }

    var httpMethod: HttpMethod {
        .put
    }

    var dto: Encodable?

    init(id: String, likes: [String]) {
        self.id = id
        self.likes = likes

        var components = URLComponents()
        components.queryItems = likes.map {
            URLQueryItem(name: "likes", value: $0)
        }

        if let queryString = components.percentEncodedQuery {
            dto = queryString
        }
    }
}
