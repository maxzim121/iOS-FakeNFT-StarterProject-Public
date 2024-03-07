import Foundation

protocol NftStorageCatalog: AnyObject {
    func saveNft(_ nft: NftResult)
    func getNft(with id: String) -> NftResult?
}

// Пример простого класса, который сохраняет данные из сети
final class NftStorageImplCatalog: NftStorageCatalog {
    private var storage: [String: NftResult] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveNft(_ nft: NftResult) {
        syncQueue.async { [weak self] in
            self?.storage[nft.id] = nft
        }
    }

    func getNft(with id: String) -> NftResult? {
        syncQueue.sync {
            storage[id]
        }
    }
}
