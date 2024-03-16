//
// Created by Ruslan S. Shvetsov on 13.02.2024.
//

import Foundation

struct FetchProfileRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }

    var httpMethod: HttpMethod {
        .get
    }
}
