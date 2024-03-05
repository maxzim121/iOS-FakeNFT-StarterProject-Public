//
// Created by Ruslan S. Shvetsov on 03.03.2024.
//

@testable import FakeNFT
import Foundation

final class MockNftStorage: NftStorage {
    var savedNft: Nft?
    var returnedNft: Nft?

    func saveNft(_ nft: Nft) {
        savedNft = nft
    }

    func getNft(with id: String) -> Nft? {
        returnedNft
    }
}
