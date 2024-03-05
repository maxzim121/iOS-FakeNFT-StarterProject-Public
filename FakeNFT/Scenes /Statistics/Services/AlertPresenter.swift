//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 07.05.2023.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {

    weak var delegate: AlertPresenterDelegate?

    var alertSome: AlertViewModel

    init(
        delegate: AlertPresenterDelegate,
        alertSome: AlertViewModel
    ) {
        self.delegate = delegate
        self.alertSome = alertSome
    }

    func show() {
        let alert = UIAlertController(
            title: alertSome.title,
            message: alertSome.message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(
                                   title: alertSome.buttonText,
                                   style: .default,
                                   handler: alertSome.handler
        )
        alert.addAction(action)

        delegate?.showAlert(alert: alert)
    }
}
