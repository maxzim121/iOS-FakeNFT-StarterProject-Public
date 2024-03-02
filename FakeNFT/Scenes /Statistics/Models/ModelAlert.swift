//
//  ModelAlert.swift
//  FakeNFT
//
//  Created by Александр Медведев on 02.03.2024.
//

import UIKit

struct AlertViewModel {
    let title: String
    let message: String
    let buttonText: String
    let handler: (UIAlertAction) -> Void
}
