import UIKit
import Foundation

typealias PresenterCompletion = (Result<CatalogDetailState, Error>) -> Void

protocol CatalogViewPresenterProtocol: AnyObject {
    func cellName(indexPath: IndexPath) -> String
    func cellImage(indexPath: IndexPath) -> URL?
    func loadCollections(completion: @escaping PresenterCompletion)
    func collectionCount() -> Int
    func sortByName()
    func sortByCount()
}

final class CatalogViewPresenter {
    
    let servicesAssembly: ServicesAssembly
    private var service: CollectionsService
    private var collections: [CollectionsModel] = []
    private var state: CatalogDetailState
    
    init(servicesAssembly: ServicesAssembly, service: CollectionsService, state: CatalogDetailState) {
        self.servicesAssembly = servicesAssembly
        self.service = service
        self.state = state
    }
    
}

extension CatalogViewPresenter: CatalogViewPresenterProtocol {
    func sortByName() {
        collections = self.collections.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
    }
    
    func sortByCount() {
        collections.sort { $0.nfts.count > $1.nfts.count }
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

    
    
    func loadCollections(completion: @escaping PresenterCompletion) {
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
                completion(.success(CatalogDetailState.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func collectionCount() -> Int {
        return collections.count
    }
    
    
    
}
