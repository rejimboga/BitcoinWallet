//
//  TopUpPopupViewController.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 16.02.2025.
//

import UIKit

final class TopUpPopupViewController: BaseViewController {
    // MARK: - UI
    
    private let backgroundContentView: UIView = .init()
        .disableTranslates()
    
    private let contentView: UIView = .init()
        .disableTranslates()
        .backgroundColor(.white)
        .cornerRadius(20)
        .shadow(.black, opacity: 0.08, radius: 20)
    
    private let infoStackView: UIStackView = .init()
        .disableTranslates()
        .axis(.vertical)
        .spacing(4)
        .distribution(.fill)
    
    private let popupTitleLabel: UILabel = .init()
        .disableTranslates()
        .font(.systemFont(ofSize: 16, weight: .semibold))
        .alignment(.center)
        .text("Deposit")
    
    private let popupDescriptionLabel: UILabel = .init()
        .disableTranslates()
        .font(.systemFont(ofSize: 12, weight: .regular))
        .alignment(.center)
        .text("Enter the amount")
    
    private let closeButton: UIButton = .init()
        .disableTranslates()
        .tintColor(.gray)
        .imageWithTintColor(UIImage(systemName: "xmark.circle.fill"))
        .height(24)
        .width(24)
        .addTarget(self, selector: #selector(closeAction(_:)), event: .touchUpInside)
    
    private lazy var amountTextField: AmountTextField = .init()
        .disableTranslates()
        .backgroundColor(.systemGray5)
        .cornerRadius(8)
        .height(42)
        .leftInset()
        .keyboardType(.decimalPad)
        .placeholder("Enter the amount")
    
    private let completeButton: UIButton = .init()
        .disableTranslates()
        .text("Top up")
        .textColor(.white)
        .backgroundColor(.black)
        .font(.systemFont(ofSize: 16, weight: .semibold))
        .height(48)
        .cornerRadius(16)
        .enabled(false)
        .addTarget(self, selector: #selector(completeAction(_:)), event: .touchUpInside)
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor(.clear)
        
        constraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.runTransitionAnimation(duration: 0.1) { view in
            view.backgroundColor(.black.withAlphaComponent(0.3))
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        amountTextField.textPublisher
            .sink { [weak self] amount in
                self?.validateButton()
            }
            .store(in: &bag)
    }
    
    // MARK: - Constraints
    
    private func constraints() {
        self.view.add(
            subview: backgroundContentView,
            with: [
                backgroundContentView.topAnchor.constraint(equalTo: view.topAnchor),
                backgroundContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                backgroundContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                backgroundContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
        
        backgroundContentView.add(
            subview: contentView,
            with: [
                contentView.centerXAnchor.constraint(equalTo: backgroundContentView.centerXAnchor),
                contentView.centerYAnchor.constraint(equalTo: backgroundContentView.centerYAnchor),
                contentView.leadingAnchor.constraint(equalTo: backgroundContentView.leadingAnchor, constant: 16),
                contentView.trailingAnchor.constraint(equalTo: backgroundContentView.trailingAnchor, constant: -16)
            ]
        )
        
        contentView.add(
            subview: closeButton,
            with: [
                closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            ]
        )
        
        contentView.add(
            subview:
                infoStackView,
            with: [
                infoStackView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 4),
                infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ]
        )
        
        infoStackView.addArrangedSubviews([popupTitleLabel, popupDescriptionLabel])
        
        contentView.add(
            subview: amountTextField,
            with: [
                amountTextField.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 8),
                amountTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                amountTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ]
        )
        
        contentView.add(
            subview: completeButton,
            with: [
                completeButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 24),
                completeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                completeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
            ]
        )
    }
    
    // MARK: - Private methods
    
    @objc private func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc private func completeAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.completeButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { [weak self] _ in
            UIView.animate(withDuration: 0.15) {
                self?.completeButton.transform = CGAffineTransform.identity
            }
        }
    }

    private func validateButton() {
        guard let _ = amountTextField.doubleValue
        else {
            completeButton.enabled(false)
            return
        }
        
        completeButton.enabled(true)
    }
}
