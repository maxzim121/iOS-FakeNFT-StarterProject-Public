import UIKit
import Foundation

enum NftDetailState {
    case initial, loading, failed(Error), data
}

typealias NftCollectionPresenterCompletion = (Result<NftDetailState, Error>) -> Void

protocol NFTCollectionViewPresenterProtocol {
    func getScreenModel() -> NFTScreenModel
    func getCellModel(indexPath: IndexPath) -> NftModel
    
    func nftsCount() -> Int
    func cellImage(urlString: String) -> URL?
    func collectionCount() -> Int
    func viewDidLoad()
    func viewController(view: NFTCollectionProtocol)
}

final class NFTCollectionViewPresenter {
    
    weak var view: NFTCollectionProtocol?
    var collection: CollectionsModel
    var nfts: [NftModel] = []
    
    private var state = NftDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    var service: NftService
    
    init(collection: CollectionsModel, service: NftService) {
        self.collection = collection
        self.service = service
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showIndicator()
            loadNft()
        case .data:
//            updateCollectionViewHeight()
            view?.reloadData()
            view?.hideIndicator()
        case .failed(let error):
            view?.hideIndicator()
            print("ОШИБКА: \(error)")
        }
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
    
    func loadNft() {
        for id in collection.nfts {
            service.loadNft(id: id) { [weak self] result in
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
                    self?.state = .data
                case .failure(let error):
                    self?.state = .failed(error)
                }
            }
        }
    }
}

extension NFTCollectionViewPresenter: NFTCollectionViewPresenterProtocol {
    func viewController(view: NFTCollectionProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        state = .loading
    }
    
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
