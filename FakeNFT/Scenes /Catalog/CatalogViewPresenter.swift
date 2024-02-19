import UIKit
import Foundation

protocol CatalogViewPresenterProtocol: AnyObject {
    func cellName() -> String
    func cellImage() -> UIImage
    
}

final class CatalogViewPresenter {
    
}

extension CatalogViewPresenter: CatalogViewPresenterProtocol {
    
    func cellName() -> String {
        let cellName: String = "Peach (11)"
        return cellName
    }
    
    func cellImage() -> UIImage {
        guard let image = UIImage(named: "MockCoverCollection") else { return  UIImage()}
        return image
    }
    
}
