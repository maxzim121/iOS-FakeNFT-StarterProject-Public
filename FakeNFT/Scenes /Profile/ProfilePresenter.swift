//
// Created by Ruslan S. Shvetsov on 13.02.2024.
//

import UIKit

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    var isProfileLoaded: Bool { get set }
    func viewDidLoad()
    func setupProfileDetails(profile: ProfileRequest)
    func updateAvatar(with url: URL)
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService: ProfileService
    private let profileHelper: ProfileHelperProtocol
    private let input: ProfileDetailInput
    var isProfileLoaded = false

    init(input: ProfileDetailInput, service: ProfileService, helper: ProfileHelperProtocol) {
        self.input = input
        profileService = service
        profileHelper = helper
    }

    func viewDidLoad() {
        fetchProfile()
    }

    func setupProfileDetails(profile: ProfileRequest) {
        view?.updateProfileDetails(profile: profile)
    }

    private func fetchProfile() {
        guard let imageView = view?.avatarImageView else {
            return
        }

        imageView.kf.indicatorType = .activity
        imageView.kf.indicator?.startAnimatingView()
        profileService.fetchProfile(id: input.profileId) { [weak self] result in
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self?.isProfileLoaded = true
                    self?.view?.updateProfileDetails(profile: profile)
                    self?.updateAvatar(with: profile.avatar)
                }
            case .failure(let error):
                print("Error fetching profile: \(error)")
                self?.isProfileLoaded = false
                imageView.kf.indicator?.stopAnimatingView()
            }
        }
    }

    func updateAvatar(with url: URL) {
        guard let imageView = view?.avatarImageView else {
            return
        }

        imageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "ProfileImagePlaceholder"),
                options: [
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ]) { result in
            switch result {
            case .success(_):
                print("Avatar image successfully set")
                imageView.kf.indicator?.stopAnimatingView()
            case .failure(let error):
                print("Error setting avatar image: \(error.localizedDescription)")
                imageView.image = UIImage(named: "ProfileImagePlaceholder")
                imageView.kf.indicator?.stopAnimatingView()
            }
        }
    }
}
