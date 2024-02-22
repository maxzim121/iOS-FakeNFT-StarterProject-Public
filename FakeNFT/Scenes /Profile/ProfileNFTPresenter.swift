//
// Created by Ruslan S. Shvetsov on 21.02.2024.
//

import UIKit

protocol ProfileNFTPresenterProtocol {
    var view: ProfileNFTViewControllerProtocol? { get set }
    var isNtfsLoaded: Bool { get }
    func viewDidLoad()
    func sortNFTs(by option: SortOption)
}

enum ProfileNFTPresenterState {
    case initial, loading, failed(Error), succeeded
}

enum SortOption {
    case price
    case rating
    case name
}

final class ProfileNFTPresenter: ProfileNFTPresenterProtocol {
    weak var view: ProfileNFTViewControllerProtocol?
    private let profileService: ProfileService
    private let nftService: NftService
    private let profileHelper: ProfileHelperProtocol
    private let input: NftInput
    private var nfts: [Nft] = []
    var isNtfsLoaded = false

    private var state = ProfileNFTPresenterState.initial {
        didSet {
            stateDidChanged()
        }
    }

    init(input: NftInput,
         profileService: ProfileService,
         nftService: NftService,
         helper: ProfileHelperProtocol) {
        self.input = input
        self.profileService = profileService
        self.nftService = nftService
        profileHelper = helper
    }

    func viewDidLoad() {
        state = .loading
    }

    private func loadNfts(ids: [String]) {
        let dispatchGroup = DispatchGroup()

        ids.forEach { id in
            dispatchGroup.enter()
            nftService.loadNft(id: id) { [weak self] result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let nft):
                    self?.nfts.append(nft)
                case .failure(let error):
                    self?.isNtfsLoaded = false
                    self?.state = .failed(error)
                    print("Error loading NFT \(id): \(error)")
                }
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.isNtfsLoaded = true
            self?.state = .succeeded
        }
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadNfts(ids: input.ids)
        case .succeeded:
            view?.hideLoading()
            view?.visibleNFTs = nfts
            view?.reloadPlaceholders()
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
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
            self?.loadNfts(ids: self?.input.ids ?? [""])
        }
    }

    func sortNFTs(by option: SortOption) {
        switch option {
        case .price:
            nfts.sort { $0.price < $1.price }
        case .rating:
            nfts.sort { $0.rating > $1.rating }
        case .name:
            nfts.sort { $0.name < $1.name }
        }
        view?.visibleNFTs = nfts
        view?.reloadCollectionView()
    }

}
