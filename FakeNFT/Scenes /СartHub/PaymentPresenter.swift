//
//  Payment.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import UIKit
import SafariServices

enum PaymentError: Error {
    case failedPayment
}

protocol PaymentPresenterProtocol {
    var currenciesCellModel: [CurrencyCellModel] { get }
    func viewWillAppear()
    func payButtonTapped()
    func userAgreementButtonTapped()
    func didSelectItemAt(_ indexPath: IndexPath)
}

final class PaymentPresenter: PaymentPresenterProtocol {
    
    // MARK: - Public Properties
    weak var viewController: PaymentViewControllerProtocol?
    
    // MARK: - Private Properties
    private let networkManager: NetworkManagerProtocol
    private var paymentManager: PaymentManagerProtocol
    private let paymentRouter: PaymentRouterProtocol
    private let cartService: CartServiceProtocol
    
    // MARK: - Initializers
    init(networkManager: NetworkManagerProtocol,
         paymentManager: PaymentManagerProtocol,
         cartService: CartServiceProtocol,
         paymentRouter: PaymentRouterProtocol
    ) {
        self.networkManager = networkManager
        self.paymentManager = paymentManager
        self.cartService    = cartService
        self.paymentRouter  = paymentRouter
    }
    
    private var currencies = [CurrencyDto]() {
        didSet {
            self.changeState(with: .loaded)
        }
    }
    
    private(set) var currenciesCellModel = [CurrencyCellModel]()
    
    private var selectedCurrencyId: Int?
    
    func viewWillAppear() {
        self.fetchCurrencies()
    }
    
    func didSelectItemAt(_ indexPath: IndexPath) {
        guard let currencyId = Int(self.currencies[indexPath.row].id) else { return }
        self.selectedCurrencyId = currencyId
        self.changePayButtonState(with: .enabled)
        self.updateListCells()
    }
    
    func userAgreementButtonTapped() {
        guard let url = Constants.termsOfUseURL else { return }
        let safariViewController = SFSafariViewController(url: url)
        viewController?.presentView(safariViewController)
    }
    
    func payButtonTapped() {
        guard let currencyId = self.selectedCurrencyId else { return }
        self.changeState(with: .loading)
        self.performPayment(with: currencyId)
    }
}

// MARK: - Private Methods
private extension PaymentPresenter {
    
    func fetchCurrencies() {
        self.changeState(with: .loading)
        self.paymentManager.fetchCurrencies { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.currencies = currencies
            case .failure(let error):
                self?.changeState(with: .error)
                guard let errorModel = self?.viewController?.errorModel(error, action: { [weak self] in
                    self?.fetchCurrencies()
                }) else { return }
                self?.viewController?.showError(with: errorModel)
            }
        }
    }
    
    func performPayment(with currencyId: Int) {
        self.paymentManager
            .performPayment(with: currencyId) { [weak self] result in
                switch result {
                case .success(let model):
                    if model.success {
                        self?.changeState(with: .loaded)
                        self?.viewController?.showPaymentSuccesfulView()
                    } else {
                        self?.changeState(with: .error)
                        guard let errorModel = self?.viewController?
                            .errorModel(PaymentError.failedPayment,
                                        action: { [weak self] in
                                self?.payButtonTapped()
                            }) else { return }
                        self?.viewController?.showError(with: errorModel)
                    }
                case .failure(_):
                    self?.changeState(with: .error)
                    guard let errorModel = self?.viewController?.errorModel(PaymentError.failedPayment, action: { [weak self] in
                        self?.payButtonTapped()
                    }) else { return }
                    self?.viewController?.showError(with: errorModel)
                }
            }
    }
    
    func changeState(with state: PaymentViewState) {
        switch state {
        case .error:
            self.viewController?.removeLoadingIndicator()
            self.changePayButtonState(with: .disabled)
        case .loading:
            self.viewController?.displayLoadingIndicator()
            self.changePayButtonState(with: .loading)
        case .loaded:
            self.viewController?.removeLoadingIndicator()
            self.changePayButtonState(with: .enabled)
            self.updateListCells()
        }
    }
    
    func updateListCells() {
        
        self.currenciesCellModel = currencies
            .map { element in
                let isSelected = (Int(element.id) == selectedCurrencyId)
                return CurrencyCellModel(
                    imageURL: element.image,
                    title: element.title,
                    ticker: element.ticker,
                    isSelected: isSelected)
            }
        
        self.viewController?.refreshList()
    }
    
    func changePayButtonState(with state: PayButtonState) {
        switch state {
        case .disabled:
            viewController?
                .changeButtonState(color: .yaWhiteDayNight,
                                   isEnabled: false,
                                   isLoading: false)
        case .enabled:
            viewController?
                .changeButtonState(color: .yaBlackDayNight,
                                   isEnabled: true,
                                   isLoading: false)
        case .loading:
            viewController?
                .changeButtonState(color: .yaBlackDayNight,
                                   isEnabled: false,
                                   isLoading: true)
        }
    }
    
    // MARK: - Enums
    
    enum PaymentViewState {
        case loading
        case loaded
        case error
    }
    
    enum Constants {
        static var termsOfUseURL: URL? {
            URL(string: "https://yandex.ru/legal/practicum_termsofuse/")
        }
    }
    
    enum PayButtonState {
        case disabled
        case enabled
        case loading
    }
}
