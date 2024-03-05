import UIKit

public final class NFTCollectionModuleAssembly {
    private let servicesAssembler: ServicesAssembly
    
    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    
    public func build(collection: CollectionsModel, nftCellModuleAssembly: NFTCellModuleAssembly) -> UIViewController {
        let presenter = NFTCollectionViewPresenter(collection: collection, service: servicesAssembler.nftService, nftCellModuleAssembly: nftCellModuleAssembly, profileService: servicesAssembler.profileService)
        let viewController = NFTCollectionViewController(presenter: presenter)
        return viewController
    }
}
