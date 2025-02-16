//
//  WalletRoutes.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 16.02.2025.
//

import Foundation
import UIKit

enum WalletRoutes: Routable {
    
    case newTransaction
    case topUp
    
    var vc: UIViewController {
        switch self {
        case .newTransaction:
            return UIViewController()
        case .topUp:
            return TopUpPopupViewController()
        }
    }
}
