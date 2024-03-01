//
//  CartFactory.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import UIKit

final class CartFactory {
    func create(with context: Context) -> UIViewController {
        // TODO: - Перевести на реальную реализацию CartService после теста
        let cartService = CartServiceStub()

        let router = CartRouter()

        let presenter = CartPresenter(
            cartService: cartService,
            router: router
        )

        let controller = CartViewController(presenter: presenter)
        
        presenter.view = controller
        router.rootController = controller

        return controller
    }
}

// MARK: - Context

extension CartFactory {
    struct Context {
        let servicesAssembly: ServicesAssembly
    }
}
