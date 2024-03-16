//
// Created by Ruslan S. Shvetsov on 13.02.2024.
//

import UIKit

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    var isProfileLoaded: Bool { get set }
    func viewDidLoad()
    func setupProfileDetails(profile: ProfileRequest)
    func updateAvatar(with url: URL)
    func updateProfile(profileData: ProfileRequest)
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService: ProfileService
    private let input: ProfileDetailInput
    var isProfileLoaded = false

    init(input: ProfileDetailInput, service: ProfileService) {
        self.input = input
        profileService = service
    }

    func viewDidLoad() {
        fetchProfile()
    }

    func setupProfileDetails(profile: ProfileRequest) {
        view?.updateProfileDetails(profile: profile)
    }

    func updateProfile(profileData: ProfileRequest) {
        guard isProfileLoaded else {
            print("Profile not loaded yet.")
            return
        }
        guard let mockProfileRequest = ProfileRequest.createWithDefaultValues() else {
            print("Failed to create ProfileRequest with default values")
            return
        }
        profileService.updateProfile(id: input.profileId, profileData: profileData) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedProfile):
                    print("result", result)
                    print("updatedProfile", updatedProfile)
                    self?.view?.updateProfileDetails(profile: updatedProfile)
                    print("Profile updated successfully.")
                case .failure(let error):
                    print("Error updating profile: \(error)")
                }
            }
        }
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
                if let errorModel = self?.makeErrorModel(error) {
                    self?.view?.showError(errorModel)
                }
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
            case .success:
                print("Avatar image successfully set")
                imageView.kf.indicator?.stopAnimatingView()
            case .failure(let error):
                print("Error setting avatar image: \(error.localizedDescription)")
                imageView.image = UIImage(named: "ProfileImagePlaceholder")
                imageView.kf.indicator?.stopAnimatingView()
            }
        }
    }

    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }

        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.fetchProfile()
        }
    }
}
