import Foundation
import UIKit
import Kingfisher

protocol NFTCollectionProtocol: AnyObject {
    func reloadData()
    func showIndicator()
    func hideIndicator()
}

final class NFTCollectionViewController: UIViewController {
    private let topSpacing: CGFloat = 486.0
    private let cellHeight: CGFloat = 192.0
    private let numberOfCellsInRow: CGFloat = 3.0
    var presenter: NFTCollectionViewPresenterProtocol
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentMode = .scaleAspectFit
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    private lazy var catalogImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "Backward")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(
            self,
            action: #selector(didTapBackButton),
            for: .touchUpInside
        )
        return button
    }()
    private lazy var catalogLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Автор коллекции:"
        label.textColor = .textPrimary
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    private lazy var authorNameButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(didTapAuthorNameButton), for: .touchUpInside)
        return button
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 32
        return label
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        collectionView.register(
            NFTCollectionViewCell.self,
            forCellWithReuseIdentifier: "NFTCollectionViewCell"
        )
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    init(presenter: NFTCollectionViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewController(view: self)
        presenter.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        addSubViews()
        configureScreen()
        applyConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func didTapAuthorNameButton() {
        let webViewViewController = CatalogWebViewViewController()
        webViewViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(webViewViewController, animated: true)
    }
    func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(catalogImageView)
        scrollView.addSubview(backButton)
        scrollView.addSubview(catalogLabel)
        scrollView.addSubview(authorLabel)
        scrollView.addSubview(authorNameButton)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(collectionView)
        [scrollView, catalogImageView, catalogLabel, backButton,
         authorLabel, authorNameButton, descriptionLabel, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    func applyConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            catalogImageView.heightAnchor.constraint(equalToConstant: 310),
            catalogImageView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            catalogImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            catalogImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            catalogImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 55),
            catalogLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            catalogLabel.topAnchor.constraint(equalTo: catalogImageView.bottomAnchor, constant: 16),
            catalogLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            authorLabel.leadingAnchor.constraint(equalTo: catalogLabel.leadingAnchor),
            authorLabel.topAnchor.constraint(equalTo: catalogLabel.bottomAnchor, constant: 13),
            authorNameButton.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: 4),
            authorNameButton.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: catalogLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: catalogLabel.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func configureScreen() {
        let screenModel = presenter.getScreenModel()
        guard let url = screenModel.catalogImageUrl else { return }
        catalogImageView.kf.indicatorType = .activity
        catalogImageView.kf.setImage(with: url)
        catalogLabel.text = screenModel.labelText
        authorNameButton.setTitle(screenModel.authorName, for: .normal)
        descriptionLabel.text = screenModel.descriptionText
    }
    func updateScrollViewContentSize() {
        let numberOfRows = ceil(CGFloat(presenter.collectionCount()) / numberOfCellsInRow)
        scrollView.contentSize = CGSize(
            width: view.frame.width,
            height: topSpacing + numberOfRows * (cellHeight)
        )
    }
}

extension NFTCollectionViewController: UICollectionViewDelegate {
}

extension NFTCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        updateScrollViewContentSize()
        let count = presenter.nftsCount()
        return count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NFTCollectionViewCell", for: indexPath) as? NFTCollectionViewCell else { return UICollectionViewCell() }
        cell.delegate = self
        let cellModel = presenter.getCellModel(indexPath: indexPath)
        cell.nftId = cellModel.id
        let likeImageName = presenter.isNftLiked(indexPath: indexPath) ? "LikeOn" : "LikeOff"
        let likeImage = UIImage(named: likeImageName)
        cell.likeButton.setImage(likeImage, for: .normal)
        let cartImageName = presenter.isNftInOrder(indexPath: indexPath) ? "CartFilled" : "CartEmpty"
        let cartImage = UIImage(named: cartImageName)?.withRenderingMode(.alwaysTemplate)
        cell.cartButton.setImage(cartImage, for: .normal)
        let url = presenter.cellImage(urlString: cellModel.images[0])
        cell.nftImageView.kf.indicatorType = .activity
        cell.nftImageView.kf.setImage(with: url) { [weak self] result in
            switch result {
            case .success(let value):
                cell.nftImageView.image = value.image
            case .failure(let error):
                print("Error loading image: \(error)")
            }
        }
        cell.nameLabel.text = cellModel.name
        cell.priceLabel.text = "\(String(describing: cellModel.price)) ETH"
        cell.starsImageView.image = UIImage(named: "\(cellModel.rating)Star")
        return cell
    }
}

extension NFTCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let indentation: CGFloat = 20
        let widthCell = (collectionView.bounds.width - indentation) / 3
        return CGSize(width: widthCell, height: 192)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 8
    }
}

extension NFTCollectionViewController: NFTCollectionProtocol {
    func showIndicator() {
        UIBlockingProgressHUD.show()
    }
    func hideIndicator() {
        UIBlockingProgressHUD.dismiss()
    }
    func reloadData() {
        collectionView.reloadData()
    }
}

extension NFTCollectionViewController: NFTCollectionControllerProtocol {
    func likeButtonTapped(liked: Bool, nftId: String) {
        if liked {
            presenter.removeNftFromLikes(nftId: nftId)
        } else {
            presenter.addNftToLikes(nftId: nftId)
        }
    }
    func cartButtonTapped(isEmpty: Bool, nftId: String) {
        if isEmpty {
            presenter.addNftToOrder(nftId: nftId)
        } else {
            presenter.removeNftFromOrder(nftId: nftId)
        }
    }

}
