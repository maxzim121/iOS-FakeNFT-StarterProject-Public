import UIKit
import Foundation

protocol NFTCollectionViewPresenterProtocol {
    func configureNftScreen(vc: NFTCollectionViewController, catalogImageView: UIImageView, catalogLabel: UILabel, authorNameButton: UIButton, descriptionLabel: UILabel)
    func configureCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}

final class NFTCollectionViewPresenter {
    
}

extension NFTCollectionViewPresenter: NFTCollectionViewPresenterProtocol {
    
    func configureNftScreen(vc: NFTCollectionViewController, catalogImageView: UIImageView, catalogLabel: UILabel, authorNameButton: UIButton, descriptionLabel: UILabel) {
        vc.catalogImageView.image = UIImage(named: "MockCoverCollection")
        vc.catalogLabel.text = "Peach"
        vc.authorNameButton.setTitle("John Doe", for: .normal)
        vc.descriptionLabel.text = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."
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
