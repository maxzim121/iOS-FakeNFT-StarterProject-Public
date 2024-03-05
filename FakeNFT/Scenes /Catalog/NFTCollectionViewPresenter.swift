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
    func nftCellPresenter() -> NFTCellPresenter
    func isNftLiked(indexPath: IndexPath) -> Bool
    func isNftInOrder(indexPath: IndexPath) -> Bool
    func likesArray() -> [String]
}

final class NFTCollectionViewPresenter {
    
    weak var view: NFTCollectionProtocol?
    private var nftCellModuleAssembly: NFTCellModuleAssembly
    private var orderService = OrderServiceImpl.shared

    var collection: CollectionsModel
    var nfts: [NftModel] = []
    var likes: [String] = []
    var order: OrderResultModel = OrderResultModel(nfts: [], id: "")
    var website = URL(string: "")
    
    private var state = NftDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    var service: NftService
    var profileService: ProfileService
    
    init(collection: CollectionsModel, service: NftService, nftCellModuleAssembly: NFTCellModuleAssembly, profileService: ProfileService) {
        self.collection = collection
        self.service = service
        self.nftCellModuleAssembly = nftCellModuleAssembly
        self.profileService = profileService
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showIndicator()
            getProfile()
            loadNft()
            loadOrder(id: "1")
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
    
    private func loadNft() {
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
    
    private func getProfile() {
        profileService.fetchProfile(id: "1") { [weak self] result in
            switch result {
            case .success(let profile):
                let fetchedProfile = Profile(name: profile.name,
                                             avatar: profile.avatar,
                                             description: profile.description,
                                             website: profile.website,
                                             nfts: profile.nfts,
                                             likes: profile.likes,
                                             id: profile.id)
                self?.likes = profile.likes
                self?.website = profile.website
            case .failure(let error):
                assertionFailure("\(error)")
            }
        }
    }
    
    private func loadOrder(id: String) {
        orderService.loadOrder(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let order):
                self.order = OrderResultModel(
                    nfts: order.nfts,
                    id: order.id
                )
                self.view?.reloadData()
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                assertionFailure("Error: \(error)")
            }
        }
    }

}

extension NFTCollectionViewPresenter: NFTCollectionViewPresenterProtocol {
    
    func isNftInOrder(indexPath: IndexPath) -> Bool {
        var result = false
        let nftId = nfts[indexPath.row].id
        for nft in order.nfts {
            if nftId == nft {
                result = true
                break
            } else { result = false }
        }
        return result
    }
    
    
    func likesArray() -> [String] {
        return likes
    }
    
    
    func isNftLiked(indexPath: IndexPath) -> Bool {
        var result = false
        let nftId = nfts[indexPath.row].id
        for like in likes {
            if nftId == like {
                result = true
                break
            } else { result = false }
        }
        return result
    }

    
        
    func nftCellPresenter() -> NFTCellPresenter {
        print(order, "МЯУ")
        return nftCellModuleAssembly.build(likes: likes, order: order)
    }
    
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
