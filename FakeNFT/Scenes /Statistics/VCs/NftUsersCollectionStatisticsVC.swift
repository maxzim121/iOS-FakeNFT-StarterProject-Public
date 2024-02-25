//
//  NftUsersCollectionStatisticsVC.swift
//  FakeNFT
//
//  Created by Александр Медведев on 24.02.2024.
//

import UIKit
//import ProgressHUD

final class NftUsersCollectionStatisticsVC: UIViewController {
    
    private let statisticsService = StatisticsService.shared
    
    private let userNfts: [String]
    
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
            setupUI()
            setupLayout()
        } else {
            print("The user has no NFTs")
        }
        //print("NftUsersCollectionStatisticsVC: nft.count = \(userNfts.count)")
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
        //TODO: download the data on the current nft and configure the cell
        UIBlockingProgressHUD.show()
        statisticsService.fetchNftById(nftId: userNfts[indexPath.row]) { [weak self] result in
            DispatchQueue.main.async  {
                guard let self = self else { return }
                switch result {
                case .success(let nftById):
                    UIBlockingProgressHUD.dismiss()
                    cell.configure(infoOnNftById: nftById) //, number: nftById.rating)
                    break
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось загрузить данные в json-файле", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ок", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
        }
        
        return cell
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
