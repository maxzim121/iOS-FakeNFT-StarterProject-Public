//
//  PaymentConPresenter.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 28.04.2024.
//


import UIKit

protocol PaymentConPresenterProtocol {
    var viewController: PaymentConViewControllerProtocol? { get set }

    func viewDidLoad()
    func buttonTapped()
}

protocol PaymentConPresenterDelegate: AnyObject {
    func didTapDismissButton()
}

final class PaymentConPresenter: PaymentConPresenterProtocol {
    weak var viewController: PaymentConViewControllerProtocol?
    weak var delegate: PaymentConPresenterDelegate?
    private var configuration: Configuration

    init(configuration: Configuration) {
        self.configuration = configuration
    }

    func viewDidLoad() {
        switch configuration {
        case .success:
            viewController?.configureElements(
                imageName: "PaymentSuccededImage",
                description: TextLabels.PaymentConViewController.paymentConfirmed,
                buttonText: TextLabels.PaymentConViewController.returnButton)
        case .failure:
            viewController?.configureElements(
                imageName: "PaymentFailedImage",
                description: TextLabels.PaymentConViewController.paymentFailed,
                buttonText: TextLabels.PaymentConViewController.tryAgainButton)
        }
    }

    func buttonTapped() {
        delegate?.didTapDismissButton()
    }
}

extension PaymentConPresenter {
    enum Configuration {
        case success
        case failure
    }
}
