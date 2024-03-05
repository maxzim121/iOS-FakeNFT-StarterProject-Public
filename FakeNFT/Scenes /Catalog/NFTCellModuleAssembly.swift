//
//  NFTCellModuleAssembly.swift
//  FakeNFT
//
//  Created by Maksim Zimens on 05.03.2024.
//

import UIKit

public final class NFTCellModuleAssembly {
    private let servicesAssembler: ServicesAssembly
    
    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    
    func build(likes: [String], order: OrderResultModel) -> NFTCellPresenter {
        let presenter = NFTCellPresenter(profileService: servicesAssembler.profileService, likes: likes, order: order)
        return presenter
    }
}
