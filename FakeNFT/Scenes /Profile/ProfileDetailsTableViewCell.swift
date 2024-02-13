//
// Created by Ruslan S. Shvetsov on 11.02.2024.
//

import UIKit

final class ProfileDetailsTableViewCell: UITableViewCell, ReuseIdentifying {
    func configureCell(title: String, subtitle: Int?) {
        textLabel?.font = .bodyBold
        if let subtitle = subtitle {
            textLabel?.text = "\(title) (\(subtitle))"
        } else {
            textLabel?.text = title
        }
        let customDisclosure = UIImageView(image: UIImage(systemName: "chevron.right"))
        customDisclosure.tintColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                    ? .textOnPrimary
                    : .textPrimary
        }
        accessoryView = customDisclosure
        selectionStyle = .none
    }
}
