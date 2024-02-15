import UIKit
import Foundation

protocol CatalogViewPresenterProtocol: AnyObject {
    func configureCell(table: UITableView) -> UITableViewCell
    
}

final class CatalogViewPresenter {
    
}

extension CatalogViewPresenter: CatalogViewPresenterProtocol {
    
    func configureCell(table: UITableView) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: "NFTTableViewCell") as? NFTTableViewCell else { return UITableViewCell()}
        cell.nftNameAndNumber.text = "Peach (11)"
        cell.nftImageView.image = UIImage(named: "MockCoverCollection")
        return cell
    }
    
}
