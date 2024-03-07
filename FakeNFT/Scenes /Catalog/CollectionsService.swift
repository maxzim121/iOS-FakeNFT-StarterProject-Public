import Foundation

typealias CollectionsCompletion = (Result<[CollectionsResult], Error>) -> Void

protocol CollectionsService {
    func loadCollections(completion: @escaping CollectionsCompletion)
}

final class CollectionsServiceImpl: CollectionsService {

    private let networkClient: NetworkClient
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadCollections(completion: @escaping CollectionsCompletion) {

        let request = CollectionsRequest()
        networkClient.send(request: request, type: [CollectionsResult].self, completionQueue: .main) { result in
            switch result {
            case .success(let collections):
                completion(.success(collections))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
