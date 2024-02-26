import UIKit

final class StatisticsViewController: UIViewController {
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
        statisticsService.fetchUsers() { [weak self] result in
            DispatchQueue.main.async  {
                guard let self = self else { return }
                switch result {
                case .success:
                    UIBlockingProgressHUD.dismiss()
                    self.setupUI()
                    self.setupLayout()
                    break
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.showAlert()
                }
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось загрузить данные о пользователях в json-файле", preferredStyle: .alert)
        
        let actionRepeat = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewDidLoad()
        }
        alert.addAction(actionRepeat)
        
        let actionNo = UIAlertAction(title: "Не надо", style: .default)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true)
    }
    
    private func setupUI() {
        view.addSubview(statisticsTable)
        //setting the navigation bar
        let backButton = UIBarButtonItem()
        backButton.tintColor = .yaBlackLight
        navigationItem.backBarButtonItem = backButton
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "sortButton"), style: .done, target: self, action: #selector(didTapSort))
    }
    
    @objc private func didTapSort() {
        let controller = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        controller.addAction(.init(title: "По имени" , style: .default) { _ in
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
