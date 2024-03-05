import UIKit

final class StatisticsViewController: UIViewController {

    private var alertView: AlertPresenterProtocol?

    private let servicesAssembly: ServicesAssembly

    private let statisticsService = StatisticsService.shared

    private lazy var statisticsTable: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.dataSource = self
        table.delegate = self
        table.register(StatisticsCell.self, forCellReuseIdentifier: StatisticsCell.reuseIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .figmaWhite

        UIBlockingProgressHUD.show()
        statisticsService.fetchUsers { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success:
                    self.setupUI()
                    self.setupLayout()
                    UIBlockingProgressHUD.dismiss()
                    break
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.showAlertWithOneAction(
                        generalTitle: "Что-то пошло не так(",
                        message: "Не удалось загрузить данные о пользователях в json-файле",
                        buttonText: "Повторить",
                        handler: { _ in self.viewDidLoad() }
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

    private func setupUI() {
        view.addSubview(statisticsTable)
        // setting the navigation bar
        let backButton = UIBarButtonItem()
        backButton.tintColor = .yaBlackLight
        navigationItem.backBarButtonItem = backButton

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "sortButton"), style: .done, target: self, action: #selector(didTapSort))
    }

    @objc private func didTapSort() {
        let controller = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        controller.addAction(.init(title: "По имени", style: .default) { _ in
            UserDefaults.standard.set(SortBy.name.rawValue, forKey: "sortBy")
            self.sortAndReload()
        })
        controller.addAction(.init(title: "По рейтингу", style: .default) {_ in
            UserDefaults.standard.set(SortBy.rating.rawValue, forKey: "sortBy")
            self.sortAndReload()
        })
        controller.addAction(.init(title: "Закрыть", style: .cancel))
        present(controller, animated: true)
    }

    private func sortAndReload() {
        statisticsService.doSort()
        statisticsTable.reloadData()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            statisticsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statisticsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            statisticsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            statisticsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            ])
    }
}

extension StatisticsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return statisticsService.listOfUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsCell.reuseIdentifier, for: indexPath)
        guard let cell = (cell as? StatisticsCell) else {
            print("Did not produce the desired cell")
            return UITableViewCell()
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
        cell.configure(user: statisticsService.listOfUsers[indexPath.row])
        return cell
    }
}

extension StatisticsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = StatisticsUserPageViewController(user: statisticsService.listOfUsers[indexPath.row])
        viewController.modalPresentationStyle = .fullScreen
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension StatisticsViewController: AlertPresenterDelegate {
    func showAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
}
