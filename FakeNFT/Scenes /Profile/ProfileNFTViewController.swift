//
// Created by Ruslan S. Shvetsov on 21.02.2024.
//

import UIKit

protocol ProfileNFTViewControllerProtocol: AnyObject, ErrorView {
    var presenter: ProfileNFTPresenterProtocol? { get }
}

private enum Constants {
    static let profileId = "1"
}

final class ProfileNFTViewController: UIViewController, ProfileNFTViewControllerProtocol {
    var presenter: ProfileNFTPresenterProtocol?

    let servicesAssembly: ServicesAssembly
    private let profileHelper = ProfileHelper()
    private var profile: Profile = .standard
    private let placeholderView = PlaceholderView()
    var visibleNFTs: [String] = []

    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        let backImage = UIImage(systemName: "chevron.left", withConfiguration: config)?.withTintColor(UIColor.closeButton, renderingMode: .alwaysOriginal)
        button.setImage(backImage, for: .normal)
        button.accessibilityIdentifier = "backButton"
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let titleHeader: UILabel = {
        let label = UILabel()
        label.text = "Мои NFT"
        label.textColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                    ? .textOnPrimary
                    : .textPrimary
        }
        label.font = .bodyBold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var sortButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        let backImage = UIImage(systemName: "filemenu.and.cursorarrow", //TODO - change to common correct image
                withConfiguration: config)?.withTintColor(UIColor.closeButton, renderingMode: .alwaysOriginal)
        button.setImage(backImage, for: .normal)
        button.accessibilityIdentifier = "backButton"
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addElements()
        setupConstraints()

        if presenter == nil {
            let profileInput = ProfileDetailInput(profileId: Constants.profileId)
            presenter = ProfileNFTPresenter(
                    input: profileInput,
                    service: servicesAssembly.profileService,
                    helper: profileHelper
            )
        }

        presenter?.view = self
        presenter?.viewDidLoad()
        reloadPlaceholders(for: .noNFTs)
    }

    private func addElements() {
        view.addSubview(headerView)
        view.addSubview(placeholderView)

        headerView.addSubview(backButton)
        headerView.addSubview(titleHeader)
        headerView.addSubview(sortButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),

            headerView.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor
            ),

            headerView.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),

            headerView.heightAnchor.constraint(
                    equalToConstant: 42
            ),

            backButton.leadingAnchor.constraint(
                    equalTo: headerView.leadingAnchor
                    , constant: 9
            ),

            backButton.topAnchor.constraint(
                    equalTo: headerView.topAnchor
                    , constant: 9
            ),

            backButton.heightAnchor.constraint(
                    equalToConstant: 24
            ),

            backButton.widthAnchor.constraint(
                    equalToConstant: 24
            ),

            titleHeader.centerXAnchor.constraint(
                    equalTo: headerView.centerXAnchor
            ),

            titleHeader.topAnchor.constraint(
                    equalTo: headerView.topAnchor,
                    constant: 12
            ),

            sortButton.trailingAnchor.constraint(
                    equalTo: headerView.trailingAnchor
                    , constant: -9
            ),

            sortButton.centerYAnchor.constraint(
                    equalTo: backButton.centerYAnchor
            ),

            sortButton.widthAnchor.constraint(
                    equalToConstant: 42
            ),

            sortButton.heightAnchor.constraint(
                    equalToConstant: 42
            ),

            placeholderView.centerXAnchor.constraint(
                    equalTo: view.centerXAnchor
            ),

            placeholderView.topAnchor.constraint(
                    equalTo: headerView.bottomAnchor,
                    constant: 307
            ),
        ])
    }

    private func reloadPlaceholders(for type: PlaceholdersTypes) {
        if visibleNFTs.isEmpty {
            placeholderView.isHidden = false
            sortButton.isHidden = true
            switch type {
            case .noNFTs:
                placeholderView.configure(with: "У Вас ещё нет NFT")
            case .noFavoriteNFTs:
                placeholderView.configure(with: "У Вас ещё нет избранных NFT")
            }
        } else {
            placeholderView.isHidden = true
            sortButton.isHidden = false
        }
    }

    @objc
    private func close() {
        dismiss(animated: true)
    }
}
