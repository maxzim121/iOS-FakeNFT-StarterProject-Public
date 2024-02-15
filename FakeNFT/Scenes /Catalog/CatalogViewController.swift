import Foundation
import UIKit

final class CatalogViewController: UIViewController {
    
    
    let servicesAssembly: ServicesAssembly
    var sortButton: UIButton = UIButton()
    var nftTable: UITableView = UITableView()
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
        sortButton.setImage(UIImage(named: "CatalogSortButton"), for: .normal)
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        sortButton.addTarget(self, action: #selector(didTapSortingButton), for: .touchUpInside)
        NSLayoutConstraint.activate([
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            sortButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2)
        ])
    }
    
    private func configureNftTable() {
        nftTable.delegate = self
        nftTable.dataSource = self
        view.addSubview(nftTable)
        nftTable.separatorStyle = .none
        nftTable.translatesAutoresizingMaskIntoConstraints = false
        nftTable.isScrollEnabled = true
        nftTable.register(NFTTableViewCell.self, forCellReuseIdentifier: "NFTTableViewCell")
        
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
        guard let presenter = presenter else { return UITableViewCell()}
        return presenter.configureCell(table: nftTable)
    }
    
    
}


