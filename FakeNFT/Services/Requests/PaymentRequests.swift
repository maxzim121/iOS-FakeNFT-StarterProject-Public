//
//  PaymentRequests.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

struct CurrenciesRequest: NetworkRequest {
    let requestId = "CurrenciesRequest"
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
}

struct MakePaymentRequest: NetworkRequest {
    let requestId = "MakePaymentRequest"
    let currencyId: Int
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currencyId)")
    }
}
