//
// Created by Ruslan S. Shvetsov on 14.02.2024.
//

import Foundation

protocol ProfileService {
    func fetchProfile(id: String, completion: @escaping (Result<Profile, Error>) -> Void)
    func updateProfile(id: String, profileData: Profile, completion: @escaping (Result<Profile, Error>) -> Void)
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

    func updateProfile(id: String, profileData: Profile, completion: @escaping (Result<Profile, Error>) -> Void) {
        let profileRequest = ProfileRequest(from: profileData)
        let request = UpdateProfileRequest(id: id, profileData: profileRequest)
        networkClient.send(request: request, type: Profile.self, onResponse: completion)
    }
}

