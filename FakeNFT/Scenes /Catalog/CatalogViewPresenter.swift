import UIKit
import Foundation

enum CatalogDetailState {
    case initial, loading, failed(Error), data
}

typealias CatalogPresetnerCompletion = (Result<CatalogDetailState, Error>) -> Void

protocol CatalogViewPresenterProtocol: AnyObject {
    func cellName(indexPath: IndexPath) -> String
    func cellImage(indexPath: IndexPath) -> URL?
    func collectionCount() -> Int
    func collection(indexPath: IndexPath) -> CollectionsModel
    func applySorting(currentSortingOption: SortingOption)
    func collectionAssembly(collection: CollectionsModel) -> UIViewController
    func viewDidLoad()
    func loadSortingOption() -> SortingOption
    func viewController(view: CatalogViewProtocol)
}

final class CatalogViewPresenter {
    weak var view: CatalogViewProtocol?
    private var collectionsService: CollectionsService
    private var nftCollectionAssembly: NFTCollectionModuleAssembly
    private var currentSortingOption: SortingOption = .defaultSorting
    private var collections: [CollectionsModel] = []
    private var originalCollections: [CollectionsModel] = []
    private let userDefaults = UserDefaultsManager.shared
    private var state = CatalogDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }
    init(service: CollectionsService, nftCollectionAssembly: NFTCollectionModuleAssembly) {
        self.collectionsService = service
        self.nftCollectionAssembly = nftCollectionAssembly
    }
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showIndicator()
            loadCollections()
        case .data:
            applySorting(currentSortingOption: currentSortingOption)
            view?.reloadData()
            view?.hideIndicator()
        case .failed(let error):
            print("ОШИБКА: \(error)")
        }
    }
}

extension CatalogViewPresenter: CatalogViewPresenterProtocol {
    func viewController(view: CatalogViewProtocol) {
        self.view = view
    }
    func loadSortingOption() -> SortingOption {
        userDefaults.loadSortingOption()
    }
    func viewDidLoad() {
        state = .loading
    }
    func collectionAssembly(collection: CollectionsModel) -> UIViewController {
        nftCollectionAssembly.build(collection: collection)
    }
    func cellName(indexPath: IndexPath) -> String {
        let collectionName = collections[indexPath.row].name
        let nftCount = collections[indexPath.row].nfts.count
        let cellName = "\(collectionName) (\(nftCount))"
        return cellName
    }
    func cellImage(indexPath: IndexPath) -> URL? {
        let urlString = collections[indexPath.row].cover
        if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedString) {
            return url
        } else {
            print("Неверный URL")
            return nil
        }

    }
    func loadCollections() {
        collectionsService.loadCollections() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let collectionsResult):
                let collectionsModel = collectionsResult.map { result in
                    CollectionsModel(
                        createdAt: DateFormatter.defaultDateFormatter.date(from: result.createdAt),
                        name: result.name,
                        cover: result.cover,
                        nfts: result.nfts,
                        description: result.description,
                        author: result.author,
                        id: result.id
                    )
                }
                self.collections = collectionsModel
                self.originalCollections = self.collections
                self.state = .data
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
    func collectionCount() -> Int {
        return collections.count
    }
    func collection(indexPath: IndexPath) -> CollectionsModel {
        let collection = collections[indexPath.row]
        return collection
    }
    func applySorting(currentSortingOption: SortingOption) {
        switch currentSortingOption {
        case .name:
            collections = collections.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        case .quantity:
            collections.sort { $0.nfts.count > $1.nfts.count }
        case .defaultSorting:
            collections = originalCollections
        }
        userDefaults.saveSortingOption(currentSortingOption)
    }
}
