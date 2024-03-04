import UIKit
import Foundation

typealias NftCollectionPresenterCompletion = (Result<NftDetailState, Error>) -> Void

protocol NFTCollectionViewPresenterProtocol {
    func getScreenModel() -> NFTScreenModel
    func getCellModel(indexPath: IndexPath) -> NftModel
    func loadNft(completion: @escaping NftCollectionPresenterCompletion)
    func nftsCount() -> Int
    func cellImage(urlString: String) -> URL?
    func collectionCount() -> Int
}

final class NFTCollectionViewPresenter {
    
    var collection: CollectionsModel
    var nfts: [NftModel] = []
    
    var service: NftService
    
    init(collection: CollectionsModel, service: NftService) {
        self.collection = collection
        self.service = service
    }
    
    func getImage(_ named: String) -> UIImage {
        guard let image = UIImage(named: named) else {return (UIImage()) }
        return image
    }
    
    func coverImageUrl() -> URL? {
        let urlString = collection.cover
        if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedString) {
            return url
        } else {
            print("Неверный URL")
            return nil
        }
    }
}

extension NFTCollectionViewPresenter: NFTCollectionViewPresenterProtocol {
    func collectionCount() -> Int {
        return collection.nfts.count 
    }
    
    
    func getScreenModel() -> NFTScreenModel {
        
        let catalogImage = coverImageUrl()
        let labelText = collection.name
        let authorName = collection.author
        let descriptionText = collection.description
        let screenElements = NFTScreenModel(catalogImageUrl: catalogImage,
                                                 labelText: labelText,
                                                 authorName: authorName,
                                                 descriptionText: descriptionText)
        return screenElements
    }
    
    func getCellModel(indexPath: IndexPath) -> NftModel {
        return nfts[indexPath.row]
    }
    
    func loadNft(completion: @escaping NftCollectionPresenterCompletion) {
        let dispatchGroup = DispatchGroup()
        for id in collection.nfts {
            dispatchGroup.enter()
            service.loadNft(id: id) { [weak self] result in
                defer {
                    dispatchGroup.leave()
                }
                switch result {
                case .success(let nftResult):
                    let nftModel = NftModel(
                        createdAt: DateFormatter.defaultDateFormatter.date(from: nftResult.createdAt),
                        name: nftResult.name,
                        images: nftResult.images,
                        rating: nftResult.rating,
                        description: nftResult.description,
                        price: nftResult.price,
                        author: nftResult.author,
                        id: nftResult.id
                    )
                    self?.nfts.append(nftModel)
                    completion(.success(.data))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func nftsCount() -> Int {
        return nfts.count
    }
    
    func cellImage(urlString: String) -> URL? {
        if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedString) {
            return url
        } else {
            print("Неверный URL")
            return nil
        }
    }
    
    
}
