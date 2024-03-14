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
    let servicesAssembly = ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()
    )
}

extension CartRouter: CartRouterProtocol{
    func showPaymentTypeScreen() {
        let paymentController = PaymentFactory().create(
            with: .init(
                servicesAssembly: servicesAssembly
            )
        )
        
        rootController?.navigationController?.pushViewController(paymentController, animated: true)
    }
}
