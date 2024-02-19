import UIKit
import Foundation

protocol NFTCollectionViewPresenterProtocol {
    
    func getScreenModel() -> NFTScreenModel
    func getCellModel() -> NFTCellModel
}

final class NFTCollectionViewPresenter {
    func getImage(_ named: String) -> UIImage {
        guard let image = UIImage(named: named) else {return (UIImage()) }
        return image
    }
}

extension NFTCollectionViewPresenter: NFTCollectionViewPresenterProtocol {
    
    func getScreenModel() -> NFTScreenModel {
        let catalogImage = getImage("MockCoverCollection")
        let labelText = "Peach"
        let authorName = "John Doe"
        let descriptionText = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."
        let screenElements = NFTScreenModel(catalogImage: catalogImage,
                                                 labelText: labelText,
                                                 authorName: authorName,
                                                 descriptionText: descriptionText)
        return screenElements
    }
    
    func getCellModel() -> NFTCellModel {
        let nftImage = getImage("MockArchie")
        let nameLabel = "Archie"
        let priceLabel = "1 ETH"
        let likeImage = getImage("LikeOn")
        let starsImage = getImage("1Star")
        let cartImage = getImage("CartEmpty")
        
        let cellElements = NFTCellModel(nftImage: nftImage,
                                           nameLabel: nameLabel,
                                           priceLabel: priceLabel,
                                           likeImage: likeImage,
                                           starsImage: starsImage,
                                           cartImage: cartImage)
        return cellElements
    }
    
}
