import UIKit
import Foundation



typealias CatalogPresetnerCompletion = (Result<CatalogDetailState, Error>) -> Void

protocol CatalogViewPresenterProtocol: AnyObject {
    func cellName(indexPath: IndexPath) -> String
    func cellImage(indexPath: IndexPath) -> URL?
    func loadCollections(completion: @escaping CatalogPresetnerCompletion)
    func collectionCount() -> Int
    func collection(indexPath: IndexPath) -> CollectionsModel
    func applySorting(currentSortingOption: SortingOption)
    func collectionAssembly(collection: CollectionsModel) -> UIViewController
}

final class CatalogViewPresenter {
    
    private var service: CollectionsService
    private var nftCollectionAssembly: NFTCollectionModuleAssembly
    private var collections: [CollectionsModel] = []
    private var originalCollections: [CollectionsModel] = []
    private let userDefaults = UserDefaultsManager.shared
    
    init(service: CollectionsService, nftCollectionAssembly: NFTCollectionModuleAssembly) {
        self.service = service
        self.nftCollectionAssembly = nftCollectionAssembly
    }
    
}

extension CatalogViewPresenter: CatalogViewPresenterProtocol {
    
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

    
    
    func loadCollections(completion: @escaping CatalogPresetnerCompletion) {
        service.loadCollections() { [weak self] result in
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
                completion(.success(CatalogDetailState.data))
            case .failure(let error):
                completion(.failure(error))
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
