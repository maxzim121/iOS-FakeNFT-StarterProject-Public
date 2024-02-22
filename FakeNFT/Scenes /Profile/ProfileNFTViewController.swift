//
// Created by Ruslan S. Shvetsov on 21.02.2024.
//

import UIKit

protocol ProfileNFTViewControllerProtocol: AnyObject, ErrorView, LoadingView {
    var presenter: ProfileNFTPresenterProtocol? { get }
    var visibleNFTs: [Nft] { get set }
    func reloadPlaceholders()
}

final class ProfileNFTViewController: UIViewController, ProfileNFTViewControllerProtocol {
    lazy var activityIndicator = UIActivityIndicatorView()
    var presenter: ProfileNFTPresenterProtocol?

    let servicesAssembly: ServicesAssembly
    private let profileHelper = ProfileHelper()
    private var profile: Profile = .standard
    private let placeholderView = PlaceholderView()
    var visibleNFTs: [Nft] = []
    private var viewType: NFTViewTypes = .showNFTs

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

    private lazy var collectionView: UICollectionView = {
        let layout = viewType == .showNFTs ? createFlowLayout() : createGridLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    init(profile: Profile, servicesAssembly: ServicesAssembly, viewType: NFTViewTypes) {
        self.profile = profile
        self.servicesAssembly = servicesAssembly
        self.viewType = viewType
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
        setupCollectionView()

        if presenter == nil {
            var nftInput: NftInput
            switch viewType {
            case .showNFTs:
                nftInput = NftInput(ids: profile.nfts)
            case .showFavoriteNFTs:
                nftInput = NftInput(ids: profile.likes)
                sortButton.isHidden = true
            }

            presenter = ProfileNFTPresenter(
                    input: nftInput,
                    profileService: servicesAssembly.profileService,
                    nftService: servicesAssembly.nftService,
                    helper: profileHelper
            )
        }

        presenter?.view = self
        presenter?.viewDidLoad()
        reloadPlaceholders()
    }

    private func addElements() {
        [headerView, placeholderView, collectionView, activityIndicator].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        [backButton, titleHeader, sortButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview($0)
        }
    }

    private func setupConstraints() {
        activityIndicator.constraintCenters(to: view)

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

            collectionView.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),

            collectionView.topAnchor.constraint(
                    equalTo: headerView.bottomAnchor
                    , constant: 20
            ),

            collectionView.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),

            collectionView.bottomAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.bottomAnchor
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

    func reloadPlaceholders() {
        guard let isNFTsLoaded = presenter?.isNtfsLoaded, isNFTsLoaded else {
            sortButton.isHidden = true
            return
        }

        let placeholderText = viewType == .showNFTs ? "У Вас ещё нет NFT" : "У Вас ещё нет избранных NFT"
        let headerText = viewType == .showNFTs ? "Мои NFT" : "Избранные NFT"

        let emptyVisibleNFTs = visibleNFTs.isEmpty
        placeholderView.isHidden = !emptyVisibleNFTs
        sortButton.isHidden = emptyVisibleNFTs || viewType == .showFavoriteNFTs
        titleHeader.isHidden = emptyVisibleNFTs

        if emptyVisibleNFTs {
            placeholderView.configure(with: placeholderText)
        } else {
            titleHeader.text = headerText
            collectionView.reloadData()
        }
    }

    @objc
    private func close() {
        dismiss(animated: true)
    }
}

extension ProfileNFTViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear

        switch viewType {
        case .showNFTs:
            collectionView.register(MyNFTCell.self, forCellWithReuseIdentifier: MyNFTCell.identifier)
        case .showFavoriteNFTs:
            collectionView.register(MyNFTCell.self, forCellWithReuseIdentifier: MyNFTCell.identifier)
//            collectionView.register(FavoriteNFTCell.self, forCellWithReuseIdentifier: FavoriteNFTCell.identifier)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleNFTs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewType {
        case .showNFTs:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyNFTCell.identifier, for: indexPath) as! MyNFTCell
            cell.configure(with: visibleNFTs[indexPath.item])
            return cell
        case .showFavoriteNFTs:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyNFTCell.identifier, for: indexPath) as! MyNFTCell
            //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteNFTCell.identifier, for: indexPath) as! FavoriteNFTCell
            cell.configure(with: visibleNFTs[indexPath.item])
            return cell
        }
    }

    private func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()

        let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.sectionInset = sectionInsets

        let availableWidth = view.bounds.width - sectionInsets.left - sectionInsets.right
        layout.itemSize = CGSize(width: availableWidth, height: 140)
        layout.minimumLineSpacing = 0
        return layout
    }


    private func createGridLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 168, height: 80)

        return layout
    }
}
