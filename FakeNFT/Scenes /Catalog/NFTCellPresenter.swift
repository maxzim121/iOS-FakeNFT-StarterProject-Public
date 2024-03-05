//
//  NFTCollectionViewCellPresenter.swift
//  FakeNFT
//
//  Created by Maksim Zimens on 05.03.2024.
//

import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void
typealias LikeCompletion = (Result<Bool, Error>) -> Void

protocol NFTCellPresenterProtocol: AnyObject {
    func addNftToLikes(nftId: String)
    func removeNftFromLikes(nftId: String)
    func isNftLiked(nftId: String, completion: @escaping LikeCompletion)
}

class NFTCellPresenter {
    weak var cell: NFTCollectionViewCellProtocol?
    var likes: [String]
    var nftLiked = false
    private let profileService: ProfileService
    
    init(profileService: ProfileService, likes: [String]) {
        self.likes = likes
        self.profileService = profileService
    }
    
    private func removeNft(nftId: String) {
        var count = 0
        for like in likes {
            if like == nftId {
                likes.remove(at: count)
            }
            count += 1
        }
    }
    
    private func getProfile(completion: @escaping ProfileCompletion) {
        profileService.fetchProfile(id: "1") { [weak self] result in
            switch result {
            case .success(let profile):
                let fetchedProfile = Profile(name: profile.name,
                                             avatar: profile.avatar,
                                             description: profile.description,
                                             website: profile.website,
                                             nfts: profile.nfts,
                                             likes: profile.likes,
                                             id: profile.id)
                self?.likes = fetchedProfile.likes
                completion(.success(fetchedProfile))
            case .failure(let error):
                completion(.failure(error))
                assertionFailure("\(error)")
            }
        }
    }
    
}

extension NFTCellPresenter: NFTCellPresenterProtocol {
    func isNftLiked(nftId: String, completion: @escaping LikeCompletion) {
        getProfile() { [weak self] result in
            switch result {
            case .success(let profile):
                for like in profile.likes {
                    if nftId == like {
                        completion(.success(true))
                    } else { completion(.success(false))}
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addNftToLikes(nftId: String) {
        UIBlockingProgressHUD.show()
        likes.append(nftId)
        print(likes)
        profileService.updateLikes(id: "1", likes: []) { [weak self] result in
            switch result {
            case .success(let updatedProfile):
                UIBlockingProgressHUD.dismiss()
                self?.likes = updatedProfile.likes
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                assertionFailure("\(error)")
            }
            
        }
    }
    
    func removeNftFromLikes(nftId: String) {
        UIBlockingProgressHUD.show()
        removeNft(nftId: nftId)
        print(likes)
        profileService.updateLikes(id: "1", likes: likes) { [weak self] result in
            switch result {
            case .success(let updatedProfile):
                UIBlockingProgressHUD.dismiss()
                self?.likes = updatedProfile.likes
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                assertionFailure("\(error)")
            }
            
        }
    }
    
    
    
}
