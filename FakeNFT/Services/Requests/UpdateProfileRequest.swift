//
// Created by Ruslan S. Shvetsov on 13.02.2024.
//

import Foundation

struct UpdateProfileRequest: NetworkRequest {
    let id: String
    let profileData: ProfileRequest

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }

    var httpMethod: HttpMethod {
        .put
    }

    var dto: Encodable? {
        profileData
    }
}
