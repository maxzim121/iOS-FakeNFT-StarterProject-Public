import UIKit

public final class NFTCollectionModuleAssembly {
    private let servicesAssembler: ServicesAssembly
    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    public func build(collection: CollectionsModel) -> UIViewController {
        let presenter = NFTCollectionViewPresenter(
            collection: collection,
            service: servicesAssembler.nftServiceCatalog,
            profileService: servicesAssembler.profileService
        )
        let viewController = NFTCollectionViewController(presenter: presenter)
        return viewController
    }
}
