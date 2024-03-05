//
// Created by Ruslan S. Shvetsov on 03.03.2024.
//

@testable import FakeNFT
import Foundation

final class MockProfileService: ProfileService {
    var profile: Profile?
    var updatedProfile: Profile?
    var updateProfileCalled: Bool = false
    var updateLikesCalled: Bool = false

    func fetchProfile(id: String,
                      completion: @escaping (Result<FakeNFT.Profile, Error>) -> Void) {
        if let profile = profile {
            completion(.success(profile))
        } else {
            completion(.failure(MockError.profileNotFound))
        }
    }

    func updateProfile(id: String, profileData: FakeNFT.ProfileRequest,
                       completion: @escaping (Result<FakeNFT.Profile, Error>) -> Void) {
        updateProfileCalled = true
        if let updatedProfile = updatedProfile {
            completion(.success(updatedProfile))
        } else {
            completion(.failure(MockError.profileNotUpdated))
        }
    }

    func updateLikes(id: String, likes: [String],
                     completion: @escaping (Result<FakeNFT.Profile, Error>) -> Void) {
        updateLikesCalled = true
        if var profile = profile {
            completion(.success(profile))
        } else {
            completion(.failure(MockError.likesNotUpdated))
        }
    }
}

enum MockError: Error {
    case profileNotFound
    case profileNotUpdated
    case likesNotUpdated
}
