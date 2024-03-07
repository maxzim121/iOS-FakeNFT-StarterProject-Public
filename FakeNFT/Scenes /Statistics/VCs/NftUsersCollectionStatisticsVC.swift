//
//  NftUsersCollectionStatisticsVC.swift
//  FakeNFT
//
//  Created by Александр Медведев on 24.02.2024.
//

import UIKit

final class NftUsersCollectionStatisticsVC: UIViewController {

    private let statisticsService = StatisticsService.shared

    private let userNfts: [String]

    private var mainProfile: MainProfile?

    private var order: Order?

    private var flag: Int = 0 // counts the quantity of the downloaded userNftById

    private var alertView: AlertPresenterProtocol?

    private lazy var nftUsersCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.showsVerticalScrollIndicator = false
        collection.register(NftUsersCollectionStatisticsViewCell.self, forCellWithReuseIdentifier: NftUsersCollectionStatisticsViewCell.reuseIdentifier)
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()

    init(userNfts: [String]) {
        self.userNfts = userNfts
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .figmaWhite
        addHeader()

        if !userNfts.isEmpty {
            UIBlockingProgressHUD.show()
            generalSetup()
        }
    }

    private func generalSetup() {
        statisticsService.fetchProfile { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let mainProfile):
                    self.mainProfile = mainProfile
                    self.innerPartOfGeneralSetup()
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.showAlertWithOneAction(
                        generalTitle: "Что-то пошло не так(",
                        message: "Не удалось загрузить данные о главном профиле",
                        buttonText: "Повторить",
                        handler: { _ in self.generalSetup() }
                    )
                }
            }
        }
    }

    private func showAlertWithOneAction(generalTitle: String,
                                           message: String,
                                           buttonText: String,
                                           handler: @escaping (UIAlertAction) -> Void) {
           let alert = AlertViewModel(title: generalTitle,
                                      message: message,
                                      buttonText: buttonText,
                                      handler: handler
           )
        alertView = AlertPresenter(delegate: self, alertSome: alert)
        alertView?.show()
    }

    private func innerPartOfGeneralSetup() {
        statisticsService.fetchOrder { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let order):
                    self.order = order
                    self.setupUI()
                    self.setupLayout()
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.showAlertWithOneAction(
                        generalTitle: "Что-то пошло не так(",
                        message: "Не удалось загрузить данные о заказе",
                        buttonText: "Повторить",
                        handler: { _ in self.innerPartOfGeneralSetup() }
                    )
                }
            }
        }
    }

    private func addHeader() {
        navigationItem.title = "Коллекция NFT"
    }

    private func setupUI() {
        [nftUsersCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            nftUsersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nftUsersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            nftUsersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nftUsersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

extension NftUsersCollectionStatisticsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userNfts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NftUsersCollectionStatisticsViewCell.reuseIdentifier, for: indexPath)
        guard let cell = (cell as? NftUsersCollectionStatisticsViewCell) else {
            print("Cell of the needed type was not created")
            return UICollectionViewCell()
        }

        downloadAndConfigureCell(indexPath, cell)
        return cell
    }

    private func downloadAndConfigureCell(_ indexPath: IndexPath, _ cell: NftUsersCollectionStatisticsViewCell) {
        // Download the data on the current nft and configure the cell
        statisticsService.fetchNftById(nftId: userNfts[indexPath.row]) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let nftById):
                    guard let mainProfile = self.mainProfile,
                          let order = self.order else {
                        return
                    }
                    self.flag += 1
                    cell.delegate = self
                    cell.configure(infoOnNftById: nftById, mainProfile.likes, order.nfts)
                    if self.flag == self.userNfts.count {
                        UIBlockingProgressHUD.dismiss()
                    }
                    break
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.showAlert(indexPath, cell)
                }
            }
        }
    }

    private func showAlert(_ indexPath: IndexPath, _ cell: NftUsersCollectionStatisticsViewCell) {
        showAlertWithOneAction(
            generalTitle: "Что-то пошло не так(",
            message: "Не удалось загрузить данные о NFT",
            buttonText: "Повторить",
            handler: { [weak self] _ in
                guard let self else { return }
                self.downloadAndConfigureCell(indexPath, cell)
            }
        )
    }
}

extension NftUsersCollectionStatisticsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width-18)/3, height: 192)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension NftUsersCollectionStatisticsVC: NftUsersCollectionStatisticsViewCellDelegate {
    func cellDidTapBasket(_ cell: NftUsersCollectionStatisticsViewCell, _ inBasket: Bool) {
        guard let indexPath = nftUsersCollectionView.indexPath(for: cell) else {
            print("Can not get the indexPath of the tapped basket")
            return
        }

        guard var orderNftArray = order?.nfts else {
            return
        }
        if inBasket == true {
            // user wants to throw out the basket the tapped NFT
            if let outOfBasketNftIndexPath = orderNftArray.firstIndex(of: "\(userNfts[indexPath.row])") {
                orderNftArray.remove(at: outOfBasketNftIndexPath)
            }
        } else if inBasket == false {
            // user wants to add to basket the tapped NFT
            orderNftArray.append("\(userNfts[indexPath.row])")
        }

        updateOrderNftArrayInOrderAndUsersCollectionItem(orderNftArray, indexPath)
    }

    private func updateOrderNftArrayInOrderAndUsersCollectionItem(_ orderNftArray: [String], _ indexPath: IndexPath) {
        statisticsService.updateOrderNftArrayInOrder(orderNftArray) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let order):
                    self.order = order
                    self.nftUsersCollectionView.reloadItems(at: [indexPath])
                    UIBlockingProgressHUD.dismiss()
                    break
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.showAlertWithOneAction(
                        generalTitle: "Что-то пошло не так(",
                        message: "Не удалось загрузить данные о заказе в json-файле в результате PUT запроса",
                        buttonText: "Ок",
                        handler: { _ in }
                    )
                }
            }
        }
    }

    func cellDidTapLike(_ cell: NftUsersCollectionStatisticsViewCell, _ likeStatus: Bool) {
        // determine the indexPath of the cell, on which the likeButton was tapped
        guard let indexPath = nftUsersCollectionView.indexPath(for: cell) else {
            print("Can not get the indexPath of the tapped like")
            return
        }
        // change the likesArray after the last tap on the likeButton
        guard var likesArray = mainProfile?.likes else { return }
        if likeStatus == true {
            // user wants to dislike the tapped NFT
            if let dislikedNftIndexPath = likesArray.firstIndex(of: "\(userNfts[indexPath.row])") {
                likesArray.remove(at: dislikedNftIndexPath)
            }
        } else if likeStatus == false {
            // user wants to like the tapped NFT
            likesArray.append("\(userNfts[indexPath.row])")
        }
        // reload the cell according the changed mainProfile
        updateLikesArrayInMainProfileAndUsersCollectionItem(likesArray, indexPath)
    }

    private func updateLikesArrayInMainProfileAndUsersCollectionItem(_ likesArray: [String],
                                                                     _ indexPath: IndexPath) {
        statisticsService.updateLikesArrayInMainProfile(likesArray) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let mainProfile):
                    self.mainProfile = mainProfile
                    self.nftUsersCollectionView.reloadItems(at: [indexPath])
                    UIBlockingProgressHUD.dismiss()
                    break
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.showAlertWithOneAction(
                        generalTitle: "Что-то пошло не так(",
                        message: "Не удалось загрузить данные о главном профиле в json-файле в результате PUT запроса",
                        buttonText: "Ок",
                        handler: { _ in }
                    )
                }
            }
        }
    }
}

extension NftUsersCollectionStatisticsVC: AlertPresenterDelegate {
    func showAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
}
