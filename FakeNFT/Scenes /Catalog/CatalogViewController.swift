import Foundation
import Kingfisher
import UIKit
import ProgressHUD

enum CatalogDetailState {
    case initial, loading, failed(Error), data
}

final class CatalogViewController: UIViewController {
    
    let servicesAssembly: ServicesAssembly
    
    private var collections: [CollectionsModel] = []
    private var service: CollectionsService
    private var state = CatalogDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "CatalogSortButton")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(
            self,
            action: #selector(didTapSortingButton),
            for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var nftTable: UITableView = {
        let tableView = UITableView()
        tableView.register(NFTTableViewCell.self, forCellReuseIdentifier: "NFTTableViewCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    var presenter: CatalogViewPresenterProtocol?
    
    init(servicesAssembly: ServicesAssembly, service: CollectionsService) {
        self.servicesAssembly = servicesAssembly
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = CatalogViewPresenter(servicesAssembly: servicesAssembly, service: service, state: state)
        configureSortButton()
        configureNftTable()
        state = .loading
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func configureSortButton() {
        view.addSubview(sortButton)
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            sortButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2)
        ])
    }
    
    private func configureNftTable() {
        view.addSubview(nftTable)
        nftTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nftTable.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            nftTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nftTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nftTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func showSortingAlert() {
        let alertController = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let sortName = UIAlertAction(
            title: "По названию",
            style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.presenter?.sortByName()
            self.nftTable.reloadData()
            self.dismiss(animated: true)
            UIBlockingProgressHUD.dismiss()
        }
        
        let sortQuantity = UIAlertAction(
            title: "По количеству NFT",
            style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.presenter?.sortByCount()
            self.nftTable.reloadData()
            self.dismiss(animated: true)
            UIBlockingProgressHUD.dismiss()
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        [sortName, sortQuantity, cancelAction].forEach {
            alertController.addAction($0)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            UIBlockingProgressHUD.show()
            loadCollections()
        case .data:
            UIBlockingProgressHUD.dismiss()
            nftTable.reloadData()
        case .failed(let error):
            print("ОШИБКА: \(error)")
        }
    }
    
    private func loadCollections() {
        presenter?.loadCollections() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let state):
                self.state = state
            case .failure(let error):
                self.state = .failed(error)
            }
            
        }
    }
    
    @objc private func didTapSortingButton() {
        showSortingAlert()
    }
}

extension CatalogViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nftCollection = NFTCollectionViewController(servicesAssembly: servicesAssembly)
        nftCollection.hidesBottomBarWhenPushed = true
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(nftCollection, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 179
    }
    
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = presenter?.collectionCount() else { return 0 }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = nftTable.dequeueReusableCell(withIdentifier: "NFTTableViewCell") as? NFTTableViewCell else { return UITableViewCell()}
        let url = presenter?.cellImage(indexPath: indexPath)
        cell.nftImageView.kf.indicatorType = .activity
        cell.nftImageView.kf.setImage(with: url) { [weak self] result in
            switch result {
            case .success(_):
                self?.nftTable.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print(error)
            }
        }
        cell.nftNameAndNumber.text = presenter?.cellName(indexPath: indexPath)
        return cell
    }
}


