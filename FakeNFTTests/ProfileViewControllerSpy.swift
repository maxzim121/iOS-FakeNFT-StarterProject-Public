//
// Created by Ruslan S. Shvetsov on 03.03.2024.
//

@testable import FakeNFT
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var avatarImageView = UIImageView()
    var updateProfileDetailsCalled: Bool = false
    var updateProfileWebsiteCalled: Bool = false
    var showErrorCalled: Bool = false
    var updatedProfileDetails: Profile?
    var updatedProfileRequest: ProfileRequest?
    var errorModel: ErrorModel?

    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        avatarImageView = UIImageView()
        self.presenter?.view = self
    }

    func updateProfileDetails(profile: Profile) {
        updateProfileDetailsCalled = true
        updatedProfileDetails = profile
    }

    func updateProfileDetails(profile: ProfileRequest) {
        updateProfileDetailsCalled = true
        updatedProfileRequest = profile
    }

    func updateProfileAvatar(avatar: UIImage) {
        avatarImageView.image = avatar
    }

    func updateProfileWebsite(_ url: String) {
        updateProfileWebsiteCalled = true
    }

    func showError(_ model: ErrorModel) {
        errorModel = model
        showErrorCalled = true
    }
}
