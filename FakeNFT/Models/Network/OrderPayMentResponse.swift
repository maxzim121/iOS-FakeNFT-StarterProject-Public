//
//  OrderPayMentResponse.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

struct OrderPaymentDto: Decodable {
    let success: Bool
    let orderId: String
    let id: String
}
