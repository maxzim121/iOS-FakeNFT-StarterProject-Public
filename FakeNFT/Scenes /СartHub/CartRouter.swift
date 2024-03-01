//
//  CartRouter.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import UIKit

protocol CartRouterProtocol {
    func showPaymentTypeScreen()
}

final class CartRouter {
    weak var rootController: UIViewController?
}

extension CartRouter: CartRouterProtocol{
    func showPaymentTypeScreen() {
        
    }
}
