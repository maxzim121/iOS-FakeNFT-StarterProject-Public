//
//  OrderService.swift
//  FakeNFT
//
//  Created by Maksim Zimens on 05.03.2024.
//

import Foundation

typealias OrderCompletion = (Result<OrderNetworkModel, Error>) -> Void

protocol OrderServiceProtocol {
    func loadOrder(id: String, completion: @escaping OrderCompletion)
    func putOrder(order: OrderNetworkModel, completion: @escaping OrderCompletion)
}

final class OrderServiceImpl: OrderServiceProtocol {
    static let shared = OrderServiceImpl(networkClient: DefaultNetworkClient())

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadOrder(id: String, completion: @escaping OrderCompletion) {
        let request = OrderRequest(id: id)
        networkClient.send(request: request, type: OrderNetworkModel.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func putOrder(order: OrderNetworkModel, completion: @escaping OrderCompletion) {
        let request = OrderPutRequest(id: order.id, nfts: order.nfts)
        networkClient.send(request: request, type: OrderNetworkModel.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
