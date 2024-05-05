//
//  CartControllerStub.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

final class CartServiceStub: CartServiceProtocol {
    
    private(set) var cartItems = [NFT]()
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchData(with id: String,
                   completion: @escaping (Result<[NFT], Error>) -> Void) {
        let request = CartItemsRequest(id: "1")
        networkManager.send(
            request: request,
            type: OrderResponse.self,
            id: request.requestId) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let items):
                    var nfts: [NFT] = []
                    
                    guard !items.nfts.isEmpty else {
                        return completion(.success(nfts))
                    }
                    
                    items.nfts.forEach{
                        self.fetchNFTItem(id: $0){ result in
                            switch result{
                            case .success(let nft):
                                nfts.append(nft)
                                if nfts.count == items.nfts.count {
                                    self.cartItems = nfts
                                    completion(.success(nfts))
                                }
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func addToCart(_ nft: NFT, completion: (() -> Void)?) {
        cartItems.append(nft)
        completion?()
    }
    
    func removeFromCart(with nftId: String,
                        completion: @escaping (Result<OrderResponse, Error>) -> Void) {
        
        
        let filteredNfts    = self.cartItems.filter{ $0.id != nftId }
        let updatedNfts     = filteredNfts.map{ $0.id }
        
        let request = CartPutRequest(id: 1, nfts: updatedNfts)
        
        networkManager.send(request: request,
                            type: OrderResponse.self,
                            id: request.requestId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.cartItems = filteredNfts
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: Private Methods
private extension CartServiceStub {
    
    func fetchNFTItem(id: String, completion: @escaping NftCompletion) {
        let request = NFTRequest(id: id)
        networkManager.send(request: request,
                            type: NFT.self,
                            id: request.id,
                            completion: completion)
    }
}
