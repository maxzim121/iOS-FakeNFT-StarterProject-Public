import UIKit

final class StatisticsViewController: UIViewController {
    private let servicesAssembly: ServicesAssembly
    
    private var statisticsTable: UITableView {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
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
    }
}
