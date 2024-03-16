//
// Created by Ruslan S. Shvetsov on 03.03.2024.
//

@testable import FakeNFT
import UIKit
import Kingfisher

final class MockProfileImageService: ProfileHelperProtocol {
    var fetchImageCalled = false
    var imageToReturn: UIImage?
    var errorToReturn: Error?

    func fetchImage(url: URL, options: Kingfisher.KingfisherOptionsInfo?,
                    completion: @escaping (Result<UIImage, Error>) -> Void) {
        fetchImageCalled = true

        if let image = imageToReturn {
            completion(.success(image))
        } else if let error = errorToReturn {
            completion(.failure(error))
        }
    }
}
