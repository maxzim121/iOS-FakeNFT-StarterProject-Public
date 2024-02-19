import Foundation
import UIKit

final class CatalogViewController: UIViewController {
    
    
    let servicesAssembly: ServicesAssembly
    
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
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = CatalogViewPresenter()
        configureSortButton()
        configureNftTable()
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
        )
        
        let sortQuantity = UIAlertAction(
            title: "По количеству NFT",
            style: .default
        )
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        [sortName, sortQuantity, cancelAction].forEach {
            alertController.addAction($0)
        }
        
        self.present(alertController, animated: true, completion: nil)
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = nftTable.dequeueReusableCell(withIdentifier: "NFTTableViewCell") as? NFTTableViewCell else { return UITableViewCell()}
        cell.nftImageView.image = presenter?.cellImage()
        cell.nftNameAndNumber.text = presenter?.cellName()
        return cell
    }
    
    
}


