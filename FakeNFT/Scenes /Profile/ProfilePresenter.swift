//
// Created by Ruslan S. Shvetsov on 13.02.2024.
//

import UIKit

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    let profileService: ProfileService
    let profileHelper: ProfileHelperProtocol
    private let input: ProfileDetailInput

    init(input: ProfileDetailInput, service: ProfileService, helper: ProfileHelperProtocol) {
        self.input = input
        profileService = service
        profileHelper = helper
    }

    func viewDidLoad() {
        setupProfileDetails()
        setupProfileImage()
        fetchProfile()
    }

    private func setupProfileDetails() {
        let profile: Profile = .standard
        view?.updateProfileDetails(profile: profile)
    }

    private func fetchProfile() {
        profileService.fetchProfile(id: input.profileId) { [weak self] result in
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self?.view?.updateProfileDetails(profile: profile)
                    self?.updateAvatar(with: profile.avatar)
                }
            case .failure(let error):
                print("Error fetching profile: \(error)")
            }
        }
    }

    private func updateAvatar(with url: URL) {
        profileHelper.fetchImage(url: url, options: nil) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let avatarImage):
                DispatchQueue.main.async {
                    self.view?.updateProfileAvatar(avatar: avatarImage)
                }
            case .failure(let error):
                print("Error updating avatar: \(error)")
                if let placeholderImage = UIImage(named: "ProfileImage") {
                    DispatchQueue.main.async {
                        self.view?.updateProfileAvatar(avatar: placeholderImage)
                    }
                }
            }
        }
    }

    private func setupProfileImage() {
        let profileImageURL = UserProfileConstants.defaultAvatar
        guard
                let url = URL(string: profileImageURL)
        else {
            return
        }
        profileHelper.fetchImage(url: url, options: nil) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let avatarImage):
                print("updateAvatar to profileImageURL \(url)")
                self.view?.updateProfileAvatar(avatar: avatarImage)
            case .failure(_):
                print("error updating avatar to profileImageURL \(url)")
                if let placeholderImage = UIImage(named: "ProfileImage") {
                    self.view?.updateProfileAvatar(avatar: placeholderImage)
                }
            }
        }
    }
}
