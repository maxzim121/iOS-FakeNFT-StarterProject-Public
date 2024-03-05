final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let nftStorageTest: NftStorageTest

    init(
        networkClient: NetworkClient,
        nftStorageTest: NftStorageTest,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.nftStorageTest = nftStorageTest
    }

    var nftServiceTest: NftServiceTest {
        NftServiceImplTest(
            networkClient: networkClient,
            storage: nftStorageTest
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
