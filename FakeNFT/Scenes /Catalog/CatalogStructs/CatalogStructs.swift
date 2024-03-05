import Foundation
import UIKit

struct NFTScreenModel {
    var catalogImageUrl: URL?
    var labelText: String
    var authorName: String
    var descriptionText: String
}

struct NFTCellModel {
    var nftImage: UIImage
    var nameLabel: String
    var priceLabel: String
    var likeImage: UIImage
    var starsImage: UIImage
    var cartImage: UIImage
}
