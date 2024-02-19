import UIKit

final class StatisticsViewController: UIViewController {
    private let servicesAssembly: ServicesAssembly
    let statisticsService = StatisticsService.shared
    
    private lazy var statisticsTable: UITableView = {
        let table = UITableView()
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
        statisticsService.fetchUsers(){[weak self] result in
            DispatchQueue.main.async  {
                guard let self = self else { return }
                switch result {
                case .success:
                    UIBlockingProgressHUD.dismiss()
                    print("users info are downloaded!")
                    self.setupUI()
                    self.setupLayout()
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
    }
    
    private func setupUI() {
        view.addSubview(statisticsTable)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "sortButton"), style: .done, target: self, action: #selector(didTapSort))
    }
    
    @objc
    private func didTapSort() {
        print("didTapSort")
    }
    private func setupLayout() {
        NSLayoutConstraint.activate([
            statisticsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statisticsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            statisticsTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            statisticsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}
extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(statisticsService.listOfUsers!.count)
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
}
