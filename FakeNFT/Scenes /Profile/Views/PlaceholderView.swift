//
// Created by Ruslan S. Shvetsov on 21.02.2024.
//

import UIKit

final class PlaceholderView: UIView {
    private let textPlaceholder: UILabel = {
        let textPlaceholder = UILabel()
        textPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        textPlaceholder.font = .bodyBold
        textPlaceholder.textColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                    ? .textOnPrimary
                    : .textPrimary
        }
        textPlaceholder.numberOfLines = 0
        textPlaceholder.lineBreakMode = .byWordWrapping
        textPlaceholder.textAlignment = .center
        return textPlaceholder
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupView() {
        addSubview(textPlaceholder)

        NSLayoutConstraint.activate([
            textPlaceholder.centerXAnchor.constraint(equalTo: centerXAnchor),
            textPlaceholder.centerYAnchor.constraint(equalTo: centerYAnchor),
            textPlaceholder.widthAnchor.constraint(equalToConstant: 343)
        ])
    }

    func configure(with text: String?) {
        textPlaceholder.text = text
    }
}
