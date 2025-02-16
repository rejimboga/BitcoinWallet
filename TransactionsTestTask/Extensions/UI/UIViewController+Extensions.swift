//
//  UIViewController+Extensions.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 16.02.2025.
//

import UIKit

extension UIViewController {
    
    enum TransitionStyle {
        case navigation(animated: Bool)
        case modal(presentationStyle: UIModalPresentationStyle, transitionStyle: UIModalTransitionStyle, animated: Bool)
    }
    
    func transition(to vc: Routable, as style: TransitionStyle) {
        UpdateUI { [weak self] in
            let vc = vc.vc
            switch style {
            case .navigation(let animated):
                self?.navigationController?.pushViewController(vc, animated: animated)
            case .modal(let presentationStyle, let transitionStyle, let animated):
                vc.modalPresentationStyle = presentationStyle
                vc.modalTransitionStyle = transitionStyle
                self?.present(vc, animated: animated)
            }
        }
    }
}
