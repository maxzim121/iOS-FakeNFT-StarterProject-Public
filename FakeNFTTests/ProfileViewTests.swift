//
// Created by Ruslan S. Shvetsov on 03.03.2024.
//

@testable import FakeNFT
import XCTest

private enum Constants {
    static let profileId = "1"
}

final class ProfileViewTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        let mockNetworkClient = MockNetworkClient()
        let mockNftStorage = MockNftStorage()

        let servicesAssembly = ServicesAssembly(
                networkClient: mockNetworkClient,
                nftStorage: mockNftStorage
        )

        let presenter = ProfilePresenterSpy()
        let viewController = ProfileViewController(
                presenter: presenter,
                servicesAssembly: servicesAssembly
        )

        // when
        _ = viewController.view

        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testUpdateProfile() {
        let mockNetworkClient = MockNetworkClient()
        let mockNftStorage = MockNftStorage()
        let mockProfileService = MockProfileService()

        let profileInput = ProfileDetailInput(profileId: Constants.profileId)
        let profilePresenter = ProfilePresenter(
                input: profileInput,
                service: mockProfileService
        )

        let profileViewControllerSpy = ProfileViewControllerSpy(presenter: profilePresenter)
        profilePresenter.view = profileViewControllerSpy

        profilePresenter.viewDidLoad()
        profilePresenter.isProfileLoaded = true

        let mockProfileRequest = ProfileRequest.createWithDefaultValues()
        mockProfileService.profile = .standard
        mockProfileService.updatedProfile = .standard

        let expectation = XCTestExpectation(description: "Update profile")

        profilePresenter.updateProfile(profileData: mockProfileRequest!)
        XCTAssertTrue(mockProfileService.updateProfileCalled)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(profileViewControllerSpy.updateProfileDetailsCalled)
            XCTAssertEqual(profileViewControllerSpy.updatedProfileDetails, mockProfileService.updatedProfile)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
