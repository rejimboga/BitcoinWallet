//
//  UIView+Extensions.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 16.02.2025.
//

import UIKit

extension UIView {
    
    // MARK: - UIView
    
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult
    func cornerRadius(_ value: CGFloat, maskedCorners: CACornerMask? = nil) -> Self {
        layer.cornerRadius = value
        if let maskedCorners { layer.maskedCorners = maskedCorners }
        return self
    }
    
    // MARK: - Constraints
    
    @discardableResult
    func disableTranslates() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult
    func add(subview: UIView, with constraints: [NSLayoutConstraint]) -> Self {
        addSubview(subview)
        constraints.forEach({ $0.isActive = true })
        
        return self
    }
    
    enum ConstraintType {
        case equal
        case greaterOrEqual
        case lessOrEqueal
    }
    
    @discardableResult
    func height(_ value: CGFloat, type: ConstraintType = .equal) -> Self {
        disableTranslates()
        switch type {
        case .equal:
            heightAnchor.constraint(equalToConstant: value).isActive = true
        case .greaterOrEqual:
            heightAnchor.constraint(greaterThanOrEqualToConstant: value).isActive = true
        case .lessOrEqueal:
            heightAnchor.constraint(lessThanOrEqualToConstant: value).isActive = true
        }
        
        return self
    }
    
    @discardableResult
    func width(_ value: CGFloat, type: ConstraintType = .equal) -> Self {
        switch type {
        case .equal:
            widthAnchor.constraint(equalToConstant: value).isActive = true
        case .greaterOrEqual:
            widthAnchor.constraint(greaterThanOrEqualToConstant: value).isActive = true
        case .lessOrEqueal:
            widthAnchor.constraint(lessThanOrEqualToConstant: value).isActive = true
        }
        return self
    }
    
    // MARK: - Shadow
    
    @discardableResult
    func shadow(_ color: UIColor, offset: CGSize = .zero, opacity: CGFloat, radius: CGFloat, animated: Bool = false) -> Self {
        let shadowLayer = CAShapeLayer()
        let cornerRadius = layer.cornerRadius
        
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = backgroundColor?.cgColor
        
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = Float(opacity)
        shadowLayer.shadowRadius = radius
        shadowLayer.name = "_shadowLayer"
        
        if animated {
            let animation = CABasicAnimation(keyPath: "shadowRadius")
            animation.fromValue = 0.0
            animation.toValue = radius
            animation.duration = 0.3
            shadowLayer.add(animation, forKey: animation.keyPath)
        }
        
        layer.insertSublayer(shadowLayer, at: 0)
        
        return self
    }
    
    // MARK: - Animation
    
    @discardableResult
    func runTransitionAnimation(duration: TimeInterval, animation: @escaping ((_ view: Self) -> Void), completion: (() -> Void)? = nil) -> Self {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve) { animation(self) } completion: { _ in completion?() }
        return self
    }
}
