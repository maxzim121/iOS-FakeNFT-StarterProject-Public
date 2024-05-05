//
//  CartFactory.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import UIKit

final class CartFactory {
    func create(with context: Context) -> UIViewController {
       
        let networkClient   = DefaultNetworkClient()
        let networkManager  = NetworkManager(networkClient: networkClient)
        let cartService     = CartServiceStub(networkManager: networkManager)
        
        let router = CartRouter()
        
        let presenter = CartPresenter(
            cartService: cartService,
            router: router
        )
        
        let controller = CartViewController(presenter: presenter)
        
        let navigationController = UINavigationController(rootViewController: controller)
        presenter.view = controller
        router.rootController = navigationController
        
        
        return navigationController
    }
}

// MARK: - Context

extension CartFactory {
    struct Context {
        let servicesAssembly: ServicesAssembly
    }
}
