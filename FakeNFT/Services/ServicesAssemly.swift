final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let nftStorageCatalog: NftStorageCatalog

    init(
        networkClient: NetworkClient,
        nftStorageCatalog: NftStorageCatalog,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.nftStorageCatalog = nftStorageCatalog
    }

    var nftServiceCatalog: NftServiceCatalog {
        NftServiceImplCatalog(
            networkClient: networkClient,
            storage: nftStorageCatalog
        )
    }
    var collectionsService: CollectionsService {
        CollectionsServiceImpl(
            networkClient: networkClient
        )
    }
    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    var profileService: ProfileService {
        ProfileServiceImpl(
            networkClient: networkClient
        )
    }
}
