//
// Created by Ruslan S. Shvetsov on 17.02.2024.
//

import UIKit
// swiftlint:disable:next type_body_length
final class EditProfileViewController: UIViewController, UITextFieldDelegate {
    private var profile: ProfileRequest
    private let inputProfile: Profile
    private var avatar: UIImage
    private var presenter: ProfilePresenterProtocol

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .closeButton
        button.setImage(UIImage(named: "close"), for: .normal)
        button.accessibilityIdentifier = "closeButton"
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()

    private lazy var editImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сменить фото", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)

        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center

        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.layer.cornerRadius = 35
        button.insertSubview(overlay, at: 0)

        overlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlay.heightAnchor.constraint(equalTo: button.heightAnchor),
            overlay.widthAnchor.constraint(equalTo: button.widthAnchor),
            overlay.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            overlay.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        overlay.isUserInteractionEnabled = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 35
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(editImageTapped), for: .touchUpInside)
        return button
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Имя"
        label.font = .headline3
        label.textColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                    ? .textOnPrimary
                    : .textPrimary
        }
        return label
    }()

    private lazy var nameTextField: InsetTextField = {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 24)
        let textField = InsetTextField(textInsets: insets)
        textField.placeholder = "Введите имя"
        textField.backgroundColor = .segmentInactive
        textField.clearButtonMode = .whileEditing
        textField.textColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                    ? .textOnPrimary
                    : .textPrimary
        }
        textField.font = .bodyRegular
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 12
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.returnKeyType = .done
        return textField
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.font = .headline3
        label.textColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                    ? .textOnPrimary
                    : .textPrimary
        }
        return label
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .segmentInactive

        textView.textColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                    ? .textOnPrimary
                    : .textPrimary
        }
        textView.font = .bodyRegular
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return textView
    }()

    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.text = "Сайт"
        label.font = .headline3
        label.textColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                    ? .textOnPrimary
                    : .textPrimary
        }
        return label
    }()

    private lazy var websiteTextField: InsetTextField = {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 24)
        let textField = InsetTextField(textInsets: insets)
        textField.placeholder = "Введите сайт"
        textField.backgroundColor = .segmentInactive
        textField.clearButtonMode = .whileEditing
        textField.textColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                    ? .textOnPrimary
                    : .textPrimary
        }
        textField.font = .bodyRegular
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 12
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.returnKeyType = .done
        return textField
    }()

    private lazy var activityIndicator = UIActivityIndicatorView()

    // MARK: - Init

    required init(presenter: ProfilePresenterProtocol, profile: Profile, avatar: UIImage) {
        self.presenter = presenter
        self.profile = ProfileRequest(from: profile)
        self.avatar = avatar
        inputProfile = profile
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        addElements()
        setupViews()
        nameTextField.delegate = self
        websiteTextField.delegate = self
    }

    // MARK: - private functions

    private func addElements() {
        [closeButton,
         avatarImageView,
         editImageButton,
         nameLabel,
         nameTextField,
         descriptionLabel,
         descriptionTextView,
         websiteLabel,
         websiteTextField,
         activityIndicator
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func setupViews() {
        setupCloseButton(safeArea: view.safeAreaLayoutGuide)
        setupAvatarImage(safeArea: view.safeAreaLayoutGuide)
        setupEditButton(safeArea: view.safeAreaLayoutGuide)
        setupNameLabel(safeArea: view.safeAreaLayoutGuide)
        setupNameTextField(safeArea: view.safeAreaLayoutGuide)
        setupDescriptionLabel(safeArea: view.safeAreaLayoutGuide)
        setupDescriptionTextLabel(safeArea: view.safeAreaLayoutGuide)
        setupWebsiteLabel(safeArea: view.safeAreaLayoutGuide)
        setupWebsiteTextField(safeArea: view.safeAreaLayoutGuide)
        setupProfileDetails()
        setupProfileAvatar()
        setupActivityIndicator()
    }

    private func setupCloseButton(safeArea: UILayoutGuide) {
        closeButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 42).isActive = true
        closeButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: -16).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
    }

    private func setupAvatarImage(safeArea: UILayoutGuide) {
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 22).isActive = true
        avatarImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    }

    private func setupEditButton(safeArea: UILayoutGuide) {
        editImageButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        editImageButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        editImageButton.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 22).isActive = true
        editImageButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    }

    private func setupNameLabel(safeArea: UILayoutGuide) {
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
    }

    private func setupNameTextField(safeArea: UILayoutGuide) {
        nameTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 60).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
    }

    private func setupDescriptionLabel(safeArea: UILayoutGuide) {
        descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 128).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
    }

    private func setupDescriptionTextLabel(safeArea: UILayoutGuide) {
        descriptionTextView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 164).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 132).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
    }

    private func setupWebsiteLabel(safeArea: UILayoutGuide) {
        websiteLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 320).isActive = true
        websiteLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        websiteLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
    }

    private func setupWebsiteTextField(safeArea: UILayoutGuide) {
        websiteTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 356).isActive = true
        websiteTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        websiteTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        websiteTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
    }

    private func setupActivityIndicator() {
        activityIndicator.constraintCenters(to: view)
    }

    private func updateProfileRequest() {
        profile.name = nameTextField.text ?? inputProfile.name
        profile.description = descriptionTextView.text ?? inputProfile.description
        profile.website = websiteTextField.text ?? inputProfile.website.absoluteString
        profile.likes = inputProfile.likes
    }

    private func setupProfileDetails() {
        nameTextField.text = inputProfile.name
        descriptionTextView.text = inputProfile.description
        websiteTextField.text = inputProfile.website.absoluteString
    }

    func setupProfileAvatar() {
        avatarImageView.image = avatar
    }

    @objc
    private func close() {
        updateProfileRequest()
        presenter.setupProfileDetails(profile: profile)
        presenter.updateProfile(profileData: profile)
        dismiss(animated: true)
    }

    @objc private func editImageTapped() {
        let alertController = UIAlertController(title: "Загрузить изображение", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Введите URL изображения"
        }
        let confirmAction = UIAlertAction(title: "Изменить", style: .default) { [weak self, weak alertController] _ in
            guard let urlString = alertController?.textFields?.first?.text else {
                return
            }
            if let url = URL(string: urlString) { [self]
                self?.presenter.updateAvatar(with: url)
            }
            self?.profile.avatar = urlString
        }

        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {

    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
