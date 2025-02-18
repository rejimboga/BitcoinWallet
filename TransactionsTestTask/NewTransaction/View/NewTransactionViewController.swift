//
//  NewTransactionViewController.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 17.02.2025.
//

import UIKit

final class NewTransactionViewController: BaseViewController {
    
    // MARK: - UI
    
    private let titleLabel: UILabel = .init()
        .disableTranslates()
        .font(.systemFont(ofSize: 24, weight: .bold))
        .text("New transaction")
    
    private let amountTextField: AmountTextField = .init()
        .disableTranslates()
        .backgroundColor(.systemGray5)
        .cornerRadius(8)
        .height(42)
        .leftInset()
        .keyboardType(.decimalPad)
        .placeholder("Enter the amount")
        .addDoneButtonOnKeyboard()
    
    private let categoryTitle: UILabel = .init()
        .disableTranslates()
        .font(.systemFont(ofSize: 18, weight: .regular))
        .text("Selected category:")
    
    private let dropMenuButton: UIButton = .init()
        .disableTranslates()
        .backgroundColor(.systemGray5)
        .cornerRadius(8)
    
    private let addButton: UIButton = .init()
        .disableTranslates()
        .height(48)
        .cornerRadius(24)
        .text("Add")
        .backgroundColor(.black)
        .textColor(.white)
        .enabled(false)
        .addTarget(self, selector: #selector(addTransactionAction(_:)), event: .touchUpInside)
    
    // MARK: - Properties
    
    private let viewModel: NewTransactionViewModel
    
    // MARK: - Inits
    init(viewModel: NewTransactionViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor(.white)
        
        constraints()
    }
    
    // MARK: - Bind
    
    override func bind() {
        viewModel.output.$categories
            .sink { [weak self] categories in
                self?.setupDropMenu(with: categories)
            }
            .store(in: &bag)
        
        amountTextField.textPublisher
            .sink { [weak self] _ in
                self?.validateButton()
            }
            .store(in: &bag)
    }
    
    // MARK: - Constraints
    private func constraints() {
        self.view.add(
            subview: titleLabel,
            with: [
                titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
                titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16)
            ]
        )
        
        self.view.add(
            subview: amountTextField,
            with: [
                amountTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
                amountTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
                amountTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            ]
        )
        
        self.view.add(
            subview: categoryTitle,
            with: [
                categoryTitle.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 16),
                categoryTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16)
            ]
        )
        
        self.view.add(
            subview: dropMenuButton,
            with: [
                dropMenuButton.centerYAnchor.constraint(equalTo: categoryTitle.centerYAnchor),
                dropMenuButton.leadingAnchor.constraint(equalTo: categoryTitle.trailingAnchor, constant: 8)
            ]
        )
        
        self.view.add(
            subview: addButton,
            with: [
                addButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
                addButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
                addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
            ]
        )
    }
    
    // MARK: - Private methods
    private func setupDropMenu(with categories: [String]) {
        var menuChildren: [UIMenuElement] = []
        
        for category in categories {
            menuChildren.append(UIAction(
                title: category,
                handler: { [weak self] _ in
                    self?.viewModel.trigger(.selectCategory(category))
                })
            )
        }

        dropMenuButton.menu = UIMenu(options: .displayAsPalette, children: menuChildren)
        dropMenuButton.setTitleColor(.black, for: .normal)
        dropMenuButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        dropMenuButton.semanticContentAttribute = .forceRightToLeft
        dropMenuButton.tintColor(.systemGray)
        dropMenuButton.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)

        dropMenuButton.showsMenuAsPrimaryAction = true
        dropMenuButton.changesSelectionAsPrimaryAction = true
    }
    
    private func validateButton() {
        guard let _ = amountTextField.doubleValue
        else {
            addButton.enabled(false)
            return
        }
        
        addButton.enabled(true)
    }
    
    @objc private func addTransactionAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.addButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self?.viewModel.trigger(.addTransaction(self?.amountTextField.doubleValue ?? 0))
        } completion: { [weak self] _ in
            UIView.animate(withDuration: 0.15) {
                self?.addButton.transform = CGAffineTransform.identity
                self?.dismiss(animated: true)
            }
        }
    }

}
