//
// Created by Ruslan S. Shvetsov on 03.03.2024.
//

@testable import FakeNFT
import XCTest

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
}
