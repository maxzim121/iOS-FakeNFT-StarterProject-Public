//
//  PaymentConViewController.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 28.04.2024.
//

import UIKit

protocol PaymentConViewControllerProtocol: AnyObject {
    func configureElements(imageName: String, description: String, buttonText: String)
}

final class PaymentConViewController: UIViewController {
    // MARK: - Private Properties
    private let imageConView: UIImageView = {
        let imageConfirmationView = UIImageView()
        imageConfirmationView.translatesAutoresizingMaskIntoConstraints = false
        return imageConfirmationView
    }()

    private let descriptionTitle: UILabel = {
        let descriptionTitle = UILabel()
        descriptionTitle.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        descriptionTitle.numberOfLines = 0
        descriptionTitle.textAlignment = .center
        descriptionTitle.textColor = .yaBlackDayNight
        descriptionTitle.translatesAutoresizingMaskIntoConstraints = false
        return descriptionTitle
    }()

    private let button: CustomButton = {
        let button = CustomButton(type: .filled, title: "", action: #selector(buttonTapped))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var presenter: PaymentConPresenter

    // MARK: - Initiializers
    init(presenter: PaymentConPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.viewController = self
        presenter.viewDidLoad()
    }

    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .yaWhiteDayNight

        [imageConView, descriptionTitle, button].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            imageConView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageConView.widthAnchor.constraint(equalTo: imageConView.heightAnchor),
            imageConView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.imageTopOffset),

            descriptionTitle.topAnchor.constraint(
                equalTo: imageConView.bottomAnchor, constant: Constants.titleTopOffset),
            descriptionTitle.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Constants.descriptionOffset),
            descriptionTitle.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Constants.descriptionOffset),

            button.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.buttonOffset),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonOffset),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonOffset),
            button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }

    @objc private func buttonTapped() {
        presenter.buttonTapped()
    }
}

// MARK: - PaymentConfirmationViewControllerProtocol
extension PaymentConViewController: PaymentConViewControllerProtocol {
    func configureElements(imageName: String, description: String, buttonText: String) {
        imageConView.image = UIImage(named: imageName)
        descriptionTitle.text = description
        button.setTitle(buttonText, for: .normal)
    }
}

// MARK: - Constants
extension PaymentConViewController {
    enum Constants {
        static let buttonOffset: CGFloat = 16
        static let imageTopOffset: CGFloat = 150
        static let descriptionOffset: CGFloat = 36
        static let titleTopOffset: CGFloat = 20
        static let buttonHeight: CGFloat = 60
    }
}
