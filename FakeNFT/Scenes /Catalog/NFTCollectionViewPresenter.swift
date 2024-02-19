import UIKit
import Foundation

protocol NFTCollectionViewPresenterProtocol {
    
    func sendScreenElements() -> NFTScreenElements
    func sendCellElements() -> NFTCellElements
}

final class NFTCollectionViewPresenter {
    func getImage(_ named: String) -> UIImage {
        guard let image = UIImage(named: named) else {return (UIImage()) }
        return image
    }
}

extension NFTCollectionViewPresenter: NFTCollectionViewPresenterProtocol {
    
    func sendScreenElements() -> NFTScreenElements {
        let catalogImage = getImage("MockCoverCollection")
        let labelText = "Peach"
        let authorName = "John Doe"
        let descriptionText = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."
        let screenElements = NFTScreenElements(catalogImage: catalogImage,
                                                 labelText: labelText,
                                                 authorName: authorName,
                                                 descriptionText: descriptionText)
        return screenElements
    }
    
    func sendCellElements() -> NFTCellElements {
        let nftImage = getImage("MockArchie")
        let nameLabel = "Archie"
        let priceLabel = "1 ETH"
        let likeImage = getImage("LikeOn")
        let starsImage = getImage("1Star")
        let cartImage = getImage("CartEmpty")
        
        let cellElements = NFTCellElements(nftImage: nftImage,
                                           nameLabel: nameLabel,
                                           priceLabel: priceLabel,
                                           likeImage: likeImage,
                                           starsImage: starsImage,
                                           cartImage: cartImage)
        return cellElements
    }

    
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NFTCollectionViewCell", for: indexPath) as? NFTCollectionViewCell else { return UICollectionViewCell() }
        cell.nftImageView.image = UIImage(named: "MockArchie")
        cell.nameLabel.text = "Archie"
        cell.priceLabel.text = "1 ETH"
        cell.likeButton.setImage(UIImage(named: "LikeOn"), for: .normal)
        cell.starsImageView.image = UIImage(named: "1Star")
        cell.cartButton.setImage(UIImage(named: "CartEmpty"), for: .normal)
        return cell
    }
    
}
