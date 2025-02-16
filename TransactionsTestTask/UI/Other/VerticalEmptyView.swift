//
//  VerticalEmptyView.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 16.02.2025.
//

import UIKit

// MARK: - EmptyViewType
enum EmptyViewType {
    case transaction
    
    var title: String {
        switch self {
        case .transaction:
            return "There are no transactions"
        }
    }
    
    var subtitle: String {
        switch self {
        case .transaction:
            return "Please, make a transaction to complete"
        }
    }
}


final class VerticalEmptyView: UIView {
    // MARK: - UI
    
    private let infoStackView: UIStackView = .init()
        .disableTranslates()
        .alignment(.center)
        .axis(.vertical)
        .spacing(8)
    
    private let titleLabel: UILabel = .init()
        .font(.systemFont(ofSize: 16, weight: .semibold))
        .alignment(.center)
        .textColor(.darkGray)
    
    private let subtitleLabel: UILabel = .init()
        .font(.systemFont(ofSize: 12, weight: .regular))
        .alignment(.center)
        .textColor(.gray)
        .numberOfLines(0)
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Constraints
    
    private func constraints() {
        add(
            subview: infoStackView,
            with: [
                infoStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                infoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                infoStackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
                infoStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
                infoStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                infoStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ]
        )
        
        infoStackView.addArrangedSubviews([titleLabel, subtitleLabel])
    }
    
    // MARK: - Public methods
    public func setup(with type: EmptyViewType) {
        titleLabel.text(type.title)
        subtitleLabel.text(type.subtitle)
    }
}
