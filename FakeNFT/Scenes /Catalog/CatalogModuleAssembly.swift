import UIKit

public final class CatalogModuleAssembly {
    private let servicesAssembler: ServicesAssembly
    
    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    
    public func build(nftCollectionAssembly: NFTCollectionModuleAssembly, nftCellModuleAssembly: NFTCellModuleAssembly) -> UIViewController {
        let presenter = CatalogViewPresenter(service: servicesAssembler.collectionsService, nftCollectionAssembly: nftCollectionAssembly, nftCellModuleAssembly: nftCellModuleAssembly)
        let viewController = CatalogViewController(presenter: presenter)
        return viewController
    }
}
