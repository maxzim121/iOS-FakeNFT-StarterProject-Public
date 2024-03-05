//
//  StatisticsUserPageViewController.swift
//  FakeNFT
//
//  Created by Александр Медведев on 21.02.2024.
//

import UIKit
import Kingfisher

final class StatisticsUserPageViewController: UIViewController {

    private let user: UserProfile

    private var avatarStub = UIImage(named: "userAvatarStub")

    private lazy var avatarView: UIImageView = {
        let avatar = UIImageView()
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = 35
        let url = URL(string: user.avatar)
        avatar.kf.indicatorType = .activity
        avatar.kf.setImage(with: url, placeholder: avatarStub)
        return avatar
    }()

    private lazy var nameLabel: UILabel = {
        let name = UILabel()
        name.font = .headline3
        name.textColor = .yaBlackLight
        name.text = user.name
        return name
    }()

    private lazy var aboutLabel: UILabel = {
       let about = UILabel()
        about.numberOfLines = 0
        about.text = user.description
        about.font = .caption2
        about.textColor = .yaBlackLight
        about.textAlignment = .left
       return about
    }()

    private lazy var usersSiteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.titleLabel?.font = .caption1
        button.setTitleColor(.yaBlackLight, for: .normal)

        button.layer.borderColor = UIColor.yaBlackLight.cgColor
        button.layer.borderWidth = 1.0
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16

        button.addTarget(self, action: #selector(didTapUsersSiteButton), for: .touchUpInside)
        return button
    }()

    private lazy var nftCollectionLabel: UILabel = {
       let label = UILabel()
        label.text = "Коллекция NFT  (\(user.nfts.count))"
        label.font = .bodyBold
        label.textColor = .yaBlackLight
       return label
    }()

    private lazy var nftCollectionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "chevronForward"), for: .normal)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(didTapNftCollectionButton), for: .touchUpInside)
        return button
    }()

    init(user: UserProfile) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .figmaWhite

        setupUI()
        setupLayout()
    }

    private func setupUI() {
        // setting the navigation bar for the NEXT pages
        let backButton = UIBarButtonItem()
        backButton.tintColor = .yaBlackLight
        navigationItem.backBarButtonItem = backButton

        [avatarView,
         nameLabel,
         aboutLabel,
         usersSiteButton,
         nftCollectionLabel,
         nftCollectionButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            avatarView.heightAnchor.constraint(equalToConstant: 70),
            avatarView.widthAnchor.constraint(equalToConstant: 70),
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            nameLabel.heightAnchor.constraint(equalToConstant: 28),
            nameLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),

            aboutLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 20),
            aboutLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            aboutLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),

            usersSiteButton.heightAnchor.constraint(equalToConstant: 40),
            usersSiteButton.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 28),
            usersSiteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            usersSiteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            nftCollectionButton.heightAnchor.constraint(equalToConstant: 54),
            nftCollectionButton.topAnchor.constraint(equalTo: usersSiteButton.bottomAnchor, constant: 40),
            nftCollectionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            nftCollectionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            nftCollectionLabel.centerYAnchor.constraint(equalTo: nftCollectionButton.centerYAnchor),
            nftCollectionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)

        ])
    }

    @objc private func didTapUsersSiteButton() {
        let webViewViewController = WebViewViewController(userWebsite: user.website)
        webViewViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(webViewViewController, animated: true)
    }

    @objc private func didTapNftCollectionButton() {
        let nftUsersCollectionStatisticsVC = NftUsersCollectionStatisticsVC(userNfts: user.nfts)
        nftUsersCollectionStatisticsVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(nftUsersCollectionStatisticsVC, animated: true)
    }
}
