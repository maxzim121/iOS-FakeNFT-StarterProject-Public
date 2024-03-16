import Foundation

typealias NftCompletionCatalog = (Result<NftResult, Error>) -> Void

protocol NftServiceCatalog {
    func loadNftCatalog(id: String, completion: @escaping NftCompletionCatalog)
}

final class NftServiceImplCatalog: NftServiceCatalog {

    private let networkClient: NetworkClient
    private let storage: NftStorageCatalog

    init(networkClient: NetworkClient, storage: NftStorageCatalog) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNftCatalog(id: String, completion: @escaping NftCompletionCatalog) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NftRequest(id: id)
        networkClient.send(request: request, type: NftResult.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
