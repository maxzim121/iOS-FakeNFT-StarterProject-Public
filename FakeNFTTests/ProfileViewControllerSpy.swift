//
// Created by Ruslan S. Shvetsov on 03.03.2024.
//

@testable import FakeNFT
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var avatarImageView = UIImageView()

    func updateProfileDetails(profile: Profile) {

    }

    func updateProfileDetails(profile: ProfileRequest) {

    }

    func updateProfileAvatar(avatar: UIImage) {
        avatarImageView.image = avatar
    }

    func updateProfileWebsite(_ url: String) {

    }

    func showError(_ model: ErrorModel) {

    }
}
