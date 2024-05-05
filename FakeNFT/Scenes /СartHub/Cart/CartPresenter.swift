//
//  File.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import UIKit

protocol CartPresenterProtocol {
    var viewController: CartViewProtocol? { get set }
    var navigationController: UINavigationController? { get set }
    var cellsModels: [CartCellModel] { get }
    
    func viewDidLoad()
    func viewWillAppear()
    
    func deleteNFT()
    func didSelectCellToDelete(id: String)
    func toPaymentButtonTapped()
    func sortButtonTapped()
    func refreshTableViewCalled()
}

final class CartPresenter: CartPresenterProtocol {
    
    
    weak var viewController: CartViewProtocol?
    weak var navigationController: UINavigationController?
    
    // MARK: - Parameters
    private let cartService: CartServiceProtocol
    private let userDefaults: UserDefaultsProtocol
    private let router: CartRouterProtocol
    
    weak var view: CartViewProtocol?
    
    private(set) var cellsModels: [CartCellModel] = []
    
    private var choosedNFTId: String?
    
    private var currentState: CartViewState = .empty {
        didSet {
            self.viewControllerShouldChangeView()
        }
    }
    
    private let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "ru_RU")
        return numberFormatter
    }()
    
    private var nfts: [NFT] {
        return cartService.cartItems
    }
    
    private var currentCartSortState = CartSortState.name.rawValue
    
    private var paymentFlowStarted = false
    
    // MARK: - Initializers
    
    init(
        userDefaults: UserDefaultsProtocol = UserDefaults.standard,
        cartService: CartServiceProtocol,
        router: CartRouterProtocol
    ) {
        self.userDefaults   = userDefaults
        self.cartService    = cartService
        self.router         = router
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        self.currentState = .empty
    }
    
    func viewWillAppear() {
        if (self.currentState == .empty ||
            self.currentState == .error) {
            self.currentState = .loading
        }
    }
    
    func refreshData() {
        let count = self.nfts.count
        let totalPrice = calculateTotalPrice()
        view?.updatePayView(count: count, price: totalPrice)
        
        if let savedSortState = userDefaults.string(forKey: Constants.cartSortStateKey) {
            currentCartSortState = savedSortState
        }
        createCellsModels()
        applySorting()
        checkNeedSwitchToCatalogVC()
    }
    
    func deleteNFT() {
        guard let choosedNFTId = self.choosedNFTId,
              let index = cellsModels
            .firstIndex(where: { $0.id == choosedNFTId }) else { return }
        
        self.cartService.removeFromCart(with: choosedNFTId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.view?.didDeleteNFT(for: IndexPath(row: index, section: 0))
                self.view?.updatePayView(count: nfts.count, price: calculateTotalPrice())
                self.cellsModels.remove(at: index)
                self.choosedNFTId = nil
                self.checkViewState()
                self.cartCountDidChanged(self.nfts.count)
            case .failure(let error):
                self.deleteItemRequestError(with: error)
            }
        }
    }
    
    func didSelectCellToDelete(id: String) {
        self.choosedNFTId = id
    }
    
    func toPaymentButtonTapped() {
        self.currentState = .empty
        router.showPaymentTypeScreen()
        paymentFlowStarted = true
    }
    
    func sortButtonTapped() {
        let alerts = [
            AlertModel(
                title: TextLabels.CartViewController.sortByPrice,
                style: .default,
                completion: { [weak self] in self?.sortByPrice() }
            ),
            AlertModel(
                title: TextLabels.CartViewController.sortByRating,
                style: .default,
                completion: { [weak self] in self?.sortByRating() }
            ),
            AlertModel(
                title: TextLabels.CartViewController.sortByName,
                style: .default, completion: { [weak self] in self?.sortByNames() }
            ),
            AlertModel(
                title: TextLabels.CartViewController.closeSorting,
                style: .cancel,
                completion: nil
            )
        ]
        view?.showAlertController(alerts: alerts)
    }
    
    func refreshTableViewCalled() {
        self.currentState = .loading
    }
}

// MARK: - Private Methods
private extension CartPresenter {
    
    func loadItems(){
        self.cartService.fetchData(with: "1") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                self.currentState = (nfts.isEmpty ? .empty : .loaded)
            case .failure(let error):
                self.loadingRequestError(with: error)
            }
        }
    }
    
    func loadingRequestError(with error: Error) {
        self.currentState = .error
        
        guard let errorModel = self.view?.errorModel(error, action: { [weak self] in
            guard let self = self else { return }
            self.currentState = .loading
        }) else { return }
        
        self.view?.showError(with: errorModel)
    }
    
    func deleteItemRequestError(with error: Error) {
        self.currentState = .error
        
        guard let errorModel = self.view?.errorModel(error, action: { [weak self] in
            guard let self = self else { return }
            self.deleteNFT()
        }) else { return }
        
        self.view?.showError(with: errorModel)
    }
    
    func calculateTotalPrice() -> String {
        let price = nfts.reduce(into: 0) { partialResult, nft in
            partialResult += nft.price
        }
        let number = NSNumber(value: price)
        let formatted = numberFormatter.string(from: number) ?? ""
        return formatted
    }
    
    func viewControllerShouldChangeView() {
        switch currentState {
        case .error:
            self.view?.removeLoadingIndicator()
        case .empty:
            self.view?.removeLoadingIndicator()
            self.view?.displayEmptyCart()
        case .loading:
            self.view?.displayLoadingIndicator()
            self.loadItems()
        case .loaded:
            self.view?.removeLoadingIndicator()
            self.refreshData()
            self.view?.displayLoadedCart()
        }
    }
    
    func checkViewState() {
        if nfts.isEmpty {
            currentState = .empty
        } else {
            currentState = .loaded
        }
    }
    
    func createCellsModels() {
        cellsModels.removeAll()
        for nft in nfts {
            let priceString = numberFormatter.string(from: NSNumber(value: nft.price)) ?? ""
            let cellModel = CartCellModel(
                id: nft.id, imageURL: nft.images.first, title: nft.name, price: "\(priceString) ETH", rating: nft.rating)
            cellsModels.append(cellModel)
        }
    }
    
    func applySorting() {
        switch currentCartSortState {
        case CartSortState.name.rawValue:
            sortByNames()
        case CartSortState.rating.rawValue:
            sortByRating()
        case CartSortState.price.rawValue:
            sortByPrice()
        default:
            return
        }
    }
    
    func sortByNames() {
        cellsModels.sort { $0.title < $1.title }
        currentCartSortState = CartSortState.name.rawValue
        didFinishSortCellsModels()
    }
    
    func sortByRating() {
        cellsModels.sort { $0.rating > $1.rating }
        currentCartSortState = CartSortState.rating.rawValue
        didFinishSortCellsModels()
    }
    
    func sortByPrice() {
        cellsModels.sort { $0.price < $1.price }
        currentCartSortState = CartSortState.price.rawValue
        didFinishSortCellsModels()
    }
    
    func didFinishSortCellsModels() {
        view?.reloadTableView()
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self else { return }
            userDefaults.set(currentCartSortState, forKey: Constants.cartSortStateKey)
        }
    }
    
    func checkNeedSwitchToCatalogVC() {
        if paymentFlowStarted && cartService.cartItems.isEmpty {
            paymentFlowStarted = false
            view?.switchToCatalogVC()
        }
    }
    
    func cartCountDidChanged(_ newCount: Int) {
        let badgeValue = newCount > 0 ? String(newCount) : nil
        self.view?.updateTabBarItem(newValue: badgeValue)
    }
}

// MARK: - CartViewState

extension CartPresenter {
    
    enum CartViewState {
        case loading
        case loaded
        case empty
        case error
    }
}

// MARK: - CartSortState

extension CartPresenter {
    enum CartSortState: String {
        case name
        case rating
        case price
    }
}

// MARK: - Constants

extension CartPresenter {
    enum Constants {
        static let cartSortStateKey = "cartSortStateKey"
    }
}
