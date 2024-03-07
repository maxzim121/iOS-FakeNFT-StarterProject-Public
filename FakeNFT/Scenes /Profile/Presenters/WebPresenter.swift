//
// Created by Ruslan S. Shvetsov on 15.02.2024.
//

import Foundation

protocol WebPresenter: AnyObject {
    func viewDidLoad()
    func didReceiveRedirect(to url: URL)
    func pageDidFinishLoading()
    func pageDidFailLoading(withError error: Error)
}

// MARK: - State

enum WebPresenterState {
    case initial, loading, failed(Error), succeeded, redirected(URL)
}

final class WebPresenterImpl: WebPresenter {
    weak var view: WebViewProtocol?
    private let input: WebPresenterInput
    private var errorAlertCount = 0

    private var state = WebPresenterState.initial {
        didSet {
            stateDidChanged()
        }
    }

    init(input: WebPresenterInput) {
        self.input = input
    }

    func viewDidLoad() {
        state = .loading
    }

    func didReceiveRedirect(to url: URL) {
        state = .redirected(url)
    }

    func pageDidFinishLoading() {
        state = .succeeded
    }

    func pageDidFailLoading(withError error: Error) {
        state = .failed(error)
    }

    private func loadWebPage() {
        view?.loadWebPage(with: input.url)
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadWebPage()
        case .redirected(let url):
            if url != input.url {
                view?.hideLoading()
            } else {
                view?.showLoading()
            }
        case .succeeded:
            view?.hideLoading()
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        }
    }

    private func makeErrorModel(_ error: Error) -> ErrorModel {
        errorAlertCount += 1
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }

        let actionText: String
        let action: () -> Void

        if errorAlertCount < 3 {
            actionText = NSLocalizedString("Error.repeat", comment: "")
            action = { [weak self] in
                self?.state = .loading
            }
        } else {
            actionText = NSLocalizedString("Error.cancel", comment: "")
            action = { [weak self] in
                self?.view?.backAction()
            }
        }
        return ErrorModel(message: message, actionText: actionText, action: action)
    }
}
