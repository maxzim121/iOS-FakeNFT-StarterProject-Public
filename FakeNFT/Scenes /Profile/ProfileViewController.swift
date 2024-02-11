//
// Created by Ruslan S. Shvetsov on 11.02.2024.
//

import UIKit

final class ProfileViewController: UIViewController {

    let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
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

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Joaquin Phoenix"
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
        label.text = "Дизайнер из Казани, люблю цифровое искусство  и бейглы. В моей коллекции уже 100+ NFT,  и еще больше — на моём сайте. Открыт к коллаборациям."
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

    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.text = "Joaquin Phoenix.com"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.accessibilityIdentifier = "websiteLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    }

    private func setupViews() {
        setupEditButton(safeArea: view.safeAreaLayoutGuide)
        setupAvatarImage(safeArea: view.safeAreaLayoutGuide)
        setupNameLabel(safeArea: view.safeAreaLayoutGuide)
        setupDescriptionLabel(safeArea: view.safeAreaLayoutGuide)
        setupWebsiteLabel(safeArea: view.safeAreaLayoutGuide)
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

    private func setupWebsiteLabel(safeArea: UILayoutGuide) {
        view.addSubview(websiteLabel)
        websiteLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        websiteLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -18).isActive = true
        websiteLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12).isActive = true
    }

    private func setupTableView(safeArea: UILayoutGuide) {
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: -4).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 4).isActive = true
        tableView.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 40).isActive = true
        tableView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }


    @objc private func editButtonTapped() {
//        let editProfileViewController = EditProfileViewController(delegate: self)
//        let navigationViewController = UINavigationController(rootViewController: editProfileViewController)
//        present(navigationViewController, animated: true)
    }
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileDetailsTableViewCell = tableView.dequeueReusableCell()

        cell.textLabel?.text = "Ячейка номер \(indexPath.row)"
        cell.textLabel?.font = .headline3

        let customDisclosure = UIImageView(image: UIImage(systemName: "chevron.right"))
        customDisclosure.tintColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                    ? .textOnPrimary
                    : .textPrimary
        }
        cell.accessoryView = customDisclosure
        return cell
    }
}
