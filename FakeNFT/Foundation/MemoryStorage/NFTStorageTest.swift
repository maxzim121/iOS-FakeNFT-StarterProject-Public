import Foundation

protocol NftStorageTest: AnyObject {
    func saveNft(_ nft: Nft)
    func getNft(with id: String) -> Nft?
}

// Пример простого класса, который сохраняет данные из сети
final class NftStorageImplTest: NftStorageTest {
    private var storage: [String: Nft] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveNft(_ nft: Nft) {
        syncQueue.async { [weak self] in
            self?.storage[nft.id] = nft
        }
    }

    func getNft(with id: String) -> Nft? {
        syncQueue.sync {
            storage[id]
        }
    }
}
