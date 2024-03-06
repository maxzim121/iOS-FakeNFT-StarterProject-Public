import Kingfisher
import UIKit
import ProgressHUD

protocol CatalogViewProtocol: AnyObject {
    func reloadData()
    func showIndicator()
    func hideIndicator()
}

enum SortingOption: Int {
    case defaultSorting
    case name
    case quantity
}

final class CatalogViewController: UIViewController {
    var presenter: CatalogViewPresenterProtocol
    private var currentSortingOption: SortingOption = .defaultSorting
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
    init(presenter: CatalogViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewController(view: self)
        presenter.viewDidLoad()
        currentSortingOption = presenter.loadSortingOption()
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
        ) { [weak self] _ in
            guard let self = self else { return }
            self.currentSortingOption = .name
            self.presenter.applySorting(currentSortingOption: .name)
            self.nftTable.reloadData()
            self.dismiss(animated: true)
        }
        let sortQuantity = UIAlertAction(
            title: "По количеству NFT",
            style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            self.currentSortingOption = .quantity
            self.presenter.applySorting(currentSortingOption: .quantity)
            self.nftTable.reloadData()
            self.dismiss(animated: true)
        }
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
        let collection = presenter.collection(indexPath: indexPath)
        let nftCollection = presenter.collectionAssembly(collection: collection)
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
        let number = presenter.collectionCount()
        return number
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = nftTable.dequeueReusableCell(withIdentifier: "NFTTableViewCell") as? NFTTableViewCell else { return UITableViewCell()}
        let url = presenter.cellImage(indexPath: indexPath)
        cell.nftImageView.kf.indicatorType = .activity
        cell.nftImageView.kf.setImage(with: url) { [weak self] result in
            switch result {
            case .success(_):
                self?.nftTable.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print(error)
            }
        }
        cell.nftNameAndNumber.text = presenter.cellName(indexPath: indexPath)
        return cell
    }
}

extension CatalogViewController: CatalogViewProtocol {
    func reloadData() {
        nftTable.reloadData()
    }
    func showIndicator() {
        UIBlockingProgressHUD.show()
    }
    func hideIndicator() {
        UIBlockingProgressHUD.dismiss()
    }
}
