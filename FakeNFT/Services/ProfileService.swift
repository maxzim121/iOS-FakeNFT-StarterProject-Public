//
// Created by Ruslan S. Shvetsov on 14.02.2024.
//

import Foundation

protocol ProfileService {
    func fetchProfile(id: String, completion: @escaping (Result<Profile, Error>) -> Void)
    func updateProfile(id: String, profileData: ProfileRequest, completion: @escaping (Result<Profile, Error>) -> Void)
    func updateLikes(id: String, likes: [String], completion: @escaping (Result<Profile, Error>) -> Void)
}

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchProfile(id: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        let request = FetchProfileRequest(id: id)
        networkClient.send(request: request, type: Profile.self, onResponse: completion)
    }

    func updateProfile(id: String, profileData: ProfileRequest,
                       completion: @escaping (Result<Profile, Error>) -> Void) {
        let request = UpdateProfileRequest(id: id, profileData: profileData)
        networkClient.send(request: request, type: Profile.self, onResponse: completion)
    }

    func updateLikes(id: String, likes: [String], completion: @escaping (Result<Profile, Error>) -> Void) {
        let request = UpdateLikesRequest(id: id, likes: likes)
        networkClient.send(request: request, type: Profile.self, onResponse: completion)
    }
}
