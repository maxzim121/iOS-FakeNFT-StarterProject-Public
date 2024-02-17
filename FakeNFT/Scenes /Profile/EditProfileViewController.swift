//
// Created by Ruslan S. Shvetsov on 17.02.2024.
//

import UIKit

final class EditProfileViewController: UIViewController, UITextFieldDelegate {

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .closeButton
        button.setImage(UIImage(named: "close"), for: .normal)
        button.accessibilityIdentifier = "closeButton"
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var avatarImageView: UIImageView = {
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
        label.text = "Имя"
        label.font = .headline3
        label.textColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                    ? .textOnPrimary
                    : .textPrimary
        }
        label.translatesAutoresizingMaskIntoConstraints = false
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
        textField.translatesAutoresizingMaskIntoConstraints = false
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
        label.translatesAutoresizingMaskIntoConstraints = false
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
        textView.translatesAutoresizingMaskIntoConstraints = false
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
        label.translatesAutoresizingMaskIntoConstraints = false
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
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.returnKeyType = .done
        return textField
    }()

    lazy var activityIndicator = UIActivityIndicatorView()

    // MARK: - Init

    // MARK: - Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupViews()
        nameTextField.delegate = self
        websiteTextField.delegate = self
//        presenter.viewDidLoad()
    }

    // MARK: - private functions

    private func setupViews() {
        setupCloseButton(safeArea: view.safeAreaLayoutGuide)
        setupAvatarImage(safeArea: view.safeAreaLayoutGuide)
        setupNameLabel(safeArea: view.safeAreaLayoutGuide)
        setupNameTextField(safeArea: view.safeAreaLayoutGuide)
        setupDescriptionLabel(safeArea: view.safeAreaLayoutGuide)
        setupDescriptionTextLabel(safeArea: view.safeAreaLayoutGuide)
        setupWebsiteLabel(safeArea: view.safeAreaLayoutGuide)
        setupWebsiteTextField(safeArea: view.safeAreaLayoutGuide)
        setupActivityIndicator()
    }

    private func setupCloseButton(safeArea: UILayoutGuide) {
        view.addSubview(closeButton)
        closeButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 42).isActive = true
        closeButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: -16).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
    }

    private func setupAvatarImage(safeArea: UILayoutGuide) {
        view.addSubview(avatarImageView)
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 22).isActive = true
        avatarImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    }

    private func setupNameLabel(safeArea: UILayoutGuide) {
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
    }

    private func setupNameTextField(safeArea: UILayoutGuide) {
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 60).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
    }

    private func setupDescriptionLabel(safeArea: UILayoutGuide) {
        view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 128).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
    }

    private func setupDescriptionTextLabel(safeArea: UILayoutGuide) {
        view.addSubview(descriptionTextView)
        descriptionTextView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 164).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 132).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
    }

    private func setupWebsiteLabel(safeArea: UILayoutGuide) {
        view.addSubview(websiteLabel)
        websiteLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 320).isActive = true
        websiteLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        websiteLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
    }

    private func setupWebsiteTextField(safeArea: UILayoutGuide) {
        view.addSubview(websiteTextField)
        websiteTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 356).isActive = true
        websiteTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        websiteTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        websiteTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
    }

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: view)
    }

    @objc
    private func close() {
        dismiss(animated: true)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {

    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
