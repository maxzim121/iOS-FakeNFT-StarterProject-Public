//
// Created by Ruslan S. Shvetsov on 11.02.2024.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject, ErrorView {
    var presenter: ProfilePresenterProtocol? { get }
    func updateProfileDetails(profile: Profile)
    func updateProfileDetails(profile: ProfileRequest)
    func updateProfileAvatar(avatar: UIImage)
    var avatarImageView: UIImageView { get }
    func updateProfileWebsite(_ url: String)
}

final class ProfileViewController: UIViewController {
    var presenter: ProfilePresenterProtocol?
    let servicesAssembly: ServicesAssembly
    private var profile: Profile = .standard

    init(presenter: ProfilePresenterProtocol, servicesAssembly: ServicesAssembly) {
        self.presenter = presenter
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .closeButton
        button.accessibilityIdentifier = "editButton"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImagePlaceholder")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                    ? .textOnPrimary
                    : .textPrimary
        }
        label.accessibilityIdentifier = "nameLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                    ? .textOnPrimary
                    : .textPrimary
        }
        label.numberOfLines = 0
        label.accessibilityIdentifier = "descriptionLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var websiteTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.font = .caption1
        textView.accessibilityIdentifier = "websiteTextView"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.isUserInteractionEnabled = true
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.yaBlueUniversal
        ]

        return textView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(ProfileDetailsTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()

        presenter?.view = self
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupViews() {
        setupEditButton(safeArea: view.safeAreaLayoutGuide)
        setupAvatarImage(safeArea: view.safeAreaLayoutGuide)
        setupNameLabel(safeArea: view.safeAreaLayoutGuide)
        setupDescriptionLabel(safeArea: view.safeAreaLayoutGuide)
        setupWebsiteTextView(safeArea: view.safeAreaLayoutGuide)
        setupTableView(safeArea: view.safeAreaLayoutGuide)
    }

    private func setupEditButton(safeArea: UILayoutGuide) {
        view.addSubview(editButton)
        editButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 42).isActive = true
        editButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 2).isActive = true
        editButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -9).isActive = true
    }

    private func setupAvatarImage(safeArea: UILayoutGuide) {
        view.addSubview(avatarImageView)
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
    }

    private func setupNameLabel(safeArea: UILayoutGuide) {
        view.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
    }

    private func setupDescriptionLabel(safeArea: UILayoutGuide) {
        view.addSubview(descriptionLabel)
        descriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -18).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20).isActive = true
    }

    private func setupWebsiteTextView(safeArea: UILayoutGuide) {
        view.addSubview(websiteTextView)
        websiteTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        websiteTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -18).isActive = true
        websiteTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12).isActive = true
    }

    private func setupTableView(safeArea: UILayoutGuide) {
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: -4).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 4).isActive = true
        tableView.topAnchor.constraint(equalTo: websiteTextView.bottomAnchor, constant: 40).isActive = true
        tableView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }

    @objc private func editButtonTapped() {
        guard let presenter = presenter as? ProfilePresenterProtocol else {
            print("Presenter or profile is nil")
            return
        }
        if !presenter.isProfileLoaded {
            let errorModel = makeErrorModel()
            showError(errorModel)
        } else {
            let defaultImage = UIImage(named: "ProfileImage") ?? UIImage()
            let editProfileViewController: UIViewController = EditProfileViewController(
                    presenter: presenter,
                    profile: profile,
                    avatar: avatarImageView.image ?? defaultImage
            )
            let navigationViewController = UINavigationController(rootViewController: editProfileViewController)
            present(navigationViewController, animated: true)
        }
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {
    func updateProfileWebsite(_ url: String) {
        if let url = URL(string: url) {
            let attributes: [NSAttributedString.Key: Any] = [
                .link: url,
                .font: UIFont.caption1
            ]

            let attributedString = NSMutableAttributedString(string: profile.website.absoluteString,
                    attributes: attributes)
            websiteTextView.attributedText = attributedString
        } else {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.caption1
            ]

            let attributedString = NSMutableAttributedString(string: profile.website.absoluteString,
                    attributes: attributes)
            websiteTextView.attributedText = attributedString
        }
    }

    func updateProfileDetails(profile: Profile) {
        self.profile = profile
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        updateProfileWebsite(profile.website.absoluteString)
        tableView.reloadData()
    }

    func updateProfileDetails(profile: ProfileRequest) {
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        updateProfileWebsite(profile.website)
    }

    func updateProfileAvatar(avatar: UIImage) {
        avatarImageView.image = avatar
    }

    private func updateProfileLikes(withUpdatedLikes updatedLikes: [String]) {
        let updatedProfile = Profile(
                name: profile.name,
                avatar: profile.avatar,
                description: profile.description,
                website: profile.website,
                nfts: profile.nfts,
                likes: updatedLikes,
                id: profile.id
        )
        profile = updatedProfile
        tableView.reloadData()
    }
}

extension ProfileViewController: ErrorView {
    private func makeErrorModel() -> ErrorModel {
        ErrorModel(
                message: "Пожалуйста, подождите, пока загрузится профиль.",
                actionText: NSLocalizedString("Error.cancel", comment: ""),
                action: {}
        )
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        let webInput = WebPresenterInput(url: URL)
        let webViewController = build(with: webInput)
        present(webViewController, animated: true)
        return false
    }
}

extension ProfileViewController {
    func build(with input: WebPresenterInput) -> UIViewController {
        let presenter = WebPresenterImpl(input: input)
        let webViewController = WebViewController(presenter: presenter)
        presenter.view = webViewController
        let navigationController = UINavigationController(rootViewController: webViewController)
        navigationController.navigationBar.tintColor = UIColor.closeButton
        return navigationController
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileDetailsTableViewCell = tableView.dequeueReusableCell()
        switch indexPath.row {
        case 0:
            cell.configureCell(title: "Мои NFT", subtitle: profile.nfts.count)
        case 1:
            cell.configureCell(title: "Избранные NFT", subtitle: profile.likes.count)
        default:
            cell.configureCell(title: "О разработчике", subtitle: nil)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let profileNFTViewController = ProfileNFTViewController(
                    profile: profile,
                    servicesAssembly: servicesAssembly,
                    viewType: .showNFTs
            )
            profileNFTViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(profileNFTViewController, animated: true)
        case 1:
            let profileFavoritesViewController = ProfileNFTViewController(
                    profile: profile,
                    servicesAssembly: servicesAssembly,
                    viewType: .showFavoriteNFTs
            )
            profileFavoritesViewController.onClose = { [weak self] updatedLikes in
                self?.updateProfileLikes(withUpdatedLikes: updatedLikes)
            }
            profileFavoritesViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(profileFavoritesViewController, animated: true)
        default:
            if let url = URL(string: Profile.standard.website.absoluteString) {
                let urlInput = WebPresenterInput(url: url)
                print(url)
                let webViewController = build(with: urlInput)
                present(webViewController, animated: true)
            }
        }
    }
}
