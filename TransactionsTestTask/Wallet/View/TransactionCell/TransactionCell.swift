//
//  TransactionCell.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 18.02.2025.
//

import UIKit

final class TransactionCell: UITableViewCell {
    
    private lazy var infoStackView: UIStackView = .init()
        .disableTranslates()
        .axis(.vertical)
        .spacing(4)
        .alignment(.leading)
        .distribution(.fill)
    
    private let categoryLabel: UILabel = .init()
        .disableTranslates()
        .textColor(.black)
        .font(.systemFont(ofSize: 14, weight: .medium))
    
    private let transactionTypeLabel: UILabel = .init()
        .disableTranslates()
        .textColor(.black)
        .font(.systemFont(ofSize: 14, weight: .regular))
    
    private let transactionAmountLabel: UILabel = .init()
        .disableTranslates()
        .textColor(.black)
        .font(.systemFont(ofSize: 14, weight: .bold))
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func constraints() {
        contentView.add(
            subview: infoStackView,
            with: [
                infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ]
        )
        
        infoStackView.addArrangedSubviews([categoryLabel, transactionTypeLabel])
        
        contentView.add(
            subview: transactionAmountLabel,
            with: [
                transactionAmountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                transactionAmountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ]
        )
    }
}

// MARK: - CellDesignable
extension TransactionCell: CellDesignable {
    func configure(with cellModel: any CellModeling) -> Self {
        guard let cellModel = cellModel as? TransactionCellModel else { return self }
        
        if let category = cellModel.transactionCategory {
            categoryLabel.text = category
            categoryLabel.isHidden = false
        } else {
            categoryLabel.isHidden = true
        }
        
        if let category = cellModel.transactionType {
            transactionTypeLabel.text = category
            transactionTypeLabel.isHidden = false
        } else {
            transactionTypeLabel.isHidden = true
        }
        
        transactionAmountLabel.text = cellModel.transactionAmount.toBalance()
        
        return self
    }
}
