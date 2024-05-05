//
//  PaymentManager.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

protocol PaymentManagerProtocol {
    
    func fetchCurrencies(completion: @escaping (Result<[CurrencyDto], Error>) -> Void)
    func performPayment(with currencyId: Int,
                        completion: @escaping (Result<OrderPaymentDto, Error>) -> Void)
}

final class PaymentManager: PaymentManagerProtocol {
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchCurrencies(completion: @escaping (Result<[CurrencyDto], Error>) -> Void) {
        let currenciesRequest = CurrenciesRequest()
        self.networkManager
            .send(request: currenciesRequest,
                  type: [CurrencyDto].self,
                  id: currenciesRequest.requestId,
                  completion: completion)
    }
    
    func performPayment(with currencyId: Int,
                        completion: @escaping (Result<OrderPaymentDto, Error>) -> Void) {
        let paymentRequest = MakePaymentRequest(currencyId: currencyId)
        self.networkManager
            .send(request: paymentRequest,
                  type: OrderPaymentDto.self,
                  id: paymentRequest.requestId, completion: completion)
    }
}
