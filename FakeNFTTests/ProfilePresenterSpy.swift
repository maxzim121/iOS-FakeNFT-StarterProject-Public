//
// Created by Ruslan S. Shvetsov on 03.03.2024.
//

@testable import FakeNFT
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var isProfileLoaded: Bool = false
    var updateProfileCalled: Bool = false
    var updateAvatarCalled: Bool = false
    var setupProfileDetailsCalled: Bool = false
    var view: ProfileViewControllerProtocol?

    func setupProfileDetails(profile: ProfileRequest) {
        setupProfileDetailsCalled = true
    }

    func updateAvatar(with url: URL) {
        updateAvatarCalled = true
    }

    func updateProfile(profileData: ProfileRequest) {
        updateProfileCalled = true
    }

    func viewDidLoad() {
        viewDidLoadCalled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            isProfileLoaded = true
        }
    }
}
