import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let profileTabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.profile", comment: ""),
            image: UIImage(systemName: "person.crop.circle.fill"),
            tag: 0
    )

    private let catalogTabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.catalog", comment: ""),
            image: UIImage(systemName: "square.stack.fill"),
            tag: 0
    )

    private let basketTabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.basket", comment: ""),
            image: UIImage(systemName: "basket.fill"),
            tag: 0
    )

    private let statisticsTabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.statistics", comment: ""),
            image: UIImage(systemName: "flag.2.crossed.fill"),
            tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let profileInput = ProfileDetailInput(profileId: Constants.profileId)
        let presenter = ProfilePresenter(
                input: profileInput,
                service: servicesAssembly.profileService
        )

        let catalogModuleAssembly = CatalogModuleAssembly(servicesAssembler: servicesAssembly)
        let nftCollectionAssembly = NFTCollectionModuleAssembly(servicesAssembler: servicesAssembly)
        let catalogController = catalogModuleAssembly.build(nftCollectionAssembly: nftCollectionAssembly)        
        let catalogNavigationController = UINavigationController(rootViewController: catalogController)
        let profileViewController = ProfileViewController(
                presenter: presenter,
                servicesAssembly: servicesAssembly
        )
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileNavigationController.setNavigationBarHidden(true, animated: false)

        let basketController = TestCatalogViewController(
                servicesAssembly: servicesAssembly
        )

        let statisticsController = StatisticsViewController(
                servicesAssembly: servicesAssembly
        )

        profileNavigationController.tabBarItem = profileTabBarItem
        catalogNavigationController.tabBarItem = catalogTabBarItem
        basketController.tabBarItem = basketTabBarItem
        statisticsController.tabBarItem = statisticsTabBarItem

        let statisticsNavigationController = UINavigationController(rootViewController: statisticsController)
        viewControllers = [profileNavigationController, catalogNavigationController, basketController, statisticsNavigationController]
        view.backgroundColor = .systemBackground
    }
}

private enum Constants {
    static let profileId = "1"
}
