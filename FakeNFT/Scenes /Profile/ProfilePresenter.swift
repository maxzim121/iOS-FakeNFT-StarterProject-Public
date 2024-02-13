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
//    let profileService: ProfileServiceProtocol TODO
    let profileHelper: ProfileHelperProtocol

    init(
//            profileService: ProfileServiceProtocol, TODO
         profileHelper: ProfileHelperProtocol) {
//        self.profileService = profileService TODO
        self.profileHelper = profileHelper
    }

    func viewDidLoad() {
        setupProfileDetails()
        setupProfileImage()
    }

    private func setupProfileImage() {
        updateAvatar()
    }

    private func setupProfileDetails() {
        let profile: Profile = .standard //TODO
//        if let profile = profileService.profile {
            view?.updateProfileDetails(profile: profile)
//        }
    }

    func updateAvatar() {
        let profileImageURL = UserProfileConstants.defaultAvatar //TODO
        guard
//                let profileImageURL = profileService.avatarURL,
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
