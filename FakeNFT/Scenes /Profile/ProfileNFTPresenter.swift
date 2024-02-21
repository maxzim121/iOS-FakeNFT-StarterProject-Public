//
// Created by Ruslan S. Shvetsov on 21.02.2024.
//

import UIKit

protocol ProfileNFTPresenterProtocol {
    var view: ProfileNFTViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class ProfileNFTPresenter: ProfileNFTPresenterProtocol {
    weak var view: ProfileNFTViewControllerProtocol?
    private let profileService: ProfileService
    private let profileHelper: ProfileHelperProtocol
    private let input: ProfileDetailInput

    init(input: ProfileDetailInput, service: ProfileService, helper: ProfileHelperProtocol) {
        self.input = input
        profileService = service
        profileHelper = helper
    }

    func viewDidLoad() {
    }
}
