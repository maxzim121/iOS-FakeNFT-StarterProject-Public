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
    
    private lazy var nftUsersCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(NftUsersCollectionStatisticsViewCell.self, forCellWithReuseIdentifier: NftUsersCollectionStatisticsViewCell.reuseIdentifier)
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    init(userNfts: [String]){
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
            statisticsService.fetchProfile { [weak self] result in
                DispatchQueue.main.async  {
                    guard let self = self else { return }
                    switch result {
                    case .success(let mainProfile):
                        UIBlockingProgressHUD.dismiss()
                        self.mainProfile = mainProfile
                        self.setupUI()
                        self.setupLayout()
                        break
                    case .failure:
                        UIBlockingProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось загрузить данные о главном профиле в json-файле", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ок", style: .default)
                        alert.addAction(action)
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    private func addHeader()  {
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
            nftUsersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
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
        //Download the data on the current nft and configure the cell
        UIBlockingProgressHUD.show()
        statisticsService.fetchNftById(nftId: userNfts[indexPath.row]) { [weak self] result in
            DispatchQueue.main.async  {
                guard let self = self else { return }
                switch result {
                case .success(let nftById):
                    UIBlockingProgressHUD.dismiss()
                    guard let mainProfile = self.mainProfile else {
                        return
                    }
                    cell.delegate = self
                    cell.configure(infoOnNftById: nftById, mainProfile.likes)
                    break
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.showAlert(indexPath, cell)
                }
            }
        }
    }
    
    private func showAlert(_ indexPath: IndexPath, _ cell: NftUsersCollectionStatisticsViewCell) {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось загрузить данные о NFT в json-файле", preferredStyle: .alert)
        
        let actionRepeat = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let self else { return }
            self.downloadAndConfigureCell(indexPath, cell)
        }
        alert.addAction(actionRepeat)
        
        let actionNo = UIAlertAction(title: "Не надо", style: .default)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true)
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
    func itemDidTapLike(_ item: NftUsersCollectionStatisticsViewCell, _ likeStatus: Bool) {
        guard let index = nftUsersCollectionView.indexPath(for: item) else {
            print("Can not get the indexPath of the tapped like")
            return
        }
        
        guard var likesArray = mainProfile?.likes else { return }
        if likeStatus == true {
            //user wants to dislike the tapped NFT
            if let dislikedNftIndex = likesArray.firstIndex(of: "\(userNfts[index.row])") {
                likesArray.remove(at: dislikedNftIndex)
            }
        }
        
        statisticsService.updateLikesArrayInMainProfile(likesArray) { [weak self] result in
            DispatchQueue.main.async  {
                guard let self = self else { return }
                switch result {
                case .success(let mainProfile):
                    UIBlockingProgressHUD.dismiss()
                    self.mainProfile = mainProfile
                    break
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось загрузить данные о главном профиле в json-файле в результате PUT запроса", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ок", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
