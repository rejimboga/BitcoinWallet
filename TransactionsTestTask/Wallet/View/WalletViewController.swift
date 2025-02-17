//
//  WalletViewController.swift
//  TransactionsTestTask
//
//

import UIKit

final class WalletViewController: BaseViewController, Navigatable {
    // MARK: - UI
    
    private let accountInfoStack: UIStackView = .init()
        .disableTranslates()
        .spacing(4)
        .distribution(.fill)
        .axis(.vertical)
    
    private let accountTitleLabel: UILabel = .init()
        .disableTranslates()
        .font(.systemFont(ofSize: 16, weight: .regular))
        .numberOfLines(1)
        .textColor(.white)
        .text("Balance BTC")
    
    private let accountBalanceLabel: UILabel = .init()
        .disableTranslates()
        .font(.systemFont(ofSize: 32, weight: .bold))
        .numberOfLines(1)
        .textColor(.white)
    
    private let btcCurrencyLabel: UILabel = .init()
        .disableTranslates()
        .font(.systemFont(ofSize: 16, weight: .medium))
        .numberOfLines(1)
        .textColor(.systemGray5)
    
    private let buttonsStack: UIStackView = .init()
        .axis(.horizontal)
        .disableTranslates()
        .spacing(20)
        .height(70)
        .distribution(.fillEqually)
    
    private let cashInButton: VerticalButton = .init()
        .disableTranslates()
        .imageWithTintColor(UIImage(systemName: "arrow.down.circle.fill"))
        .tintColor(.gray)
        .text("Top up")
        .backgroundColor(.systemGray5)
        .font(.systemFont(ofSize: 12, weight: .semibold))
        .textColor(.gray)
        .cornerRadius(20)
        .width(120)
        .addTarget(self, selector: #selector(topUp(_:)), event: .touchUpInside)
    
    private let cashOutButton: VerticalButton = .init()
        .disableTranslates()
        .imageWithTintColor(UIImage(systemName: "plus.circle.fill"))
        .tintColor(.gray)
        .text("Add transaction")
        .backgroundColor(.systemGray5)
        .font(.systemFont(ofSize: 12, weight: .semibold))
        .textColor(.gray)
        .cornerRadius(20)
        .width(120)
        .addTarget(self, selector: #selector(newTransaction(_:)), event: .touchUpInside)
    
    private let transactionsTableView: UITableView = .init()
        .disableTranslates()
        .cornerRadius(16, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    
    private let emptyView: VerticalEmptyView = .init()
        .disableTranslates()
        
    
    // MARK: - Route
    
    typealias Route = WalletRoutes
    
    // MARK: - VM
    
    private let viewModel: WalletViewModel
    
    // MARK: - Inits
    
    init(viewModel: WalletViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor(.systemGray2)
        
        constraints()
    }
    
    // MARK: - Bind
    
    override func bind() { 
        viewModel.output.$btcBalance
            .sink { [weak self] balance in
                self?.accountBalanceLabel.text = balance.toBalance()
            }
            .store(in: &bag)
        
        viewModel.output.$btcCurrency.ui
            .sink { [weak self] currency in
                self?.setupCurrencyInfo(with: currency)
            }
            .store(in: &bag)
        
        viewModel.output.$transactions
            .sink { [weak self] transactions in
                if transactions.isEmpty {
                    self?.emptyView.hidden(false, animated: true)
                    self?.emptyView.setup(with: .transaction)
                } else {
                    self?.emptyView.hidden(true, animated: true)
                    self?.transactionsTableView.reloadData()
                }
            }
            .store(in: &bag)
    }
    
    // MARK: - Constraints
    private func constraints() {
        self.view.add(
            subview: accountInfoStack,
            with: [
                accountInfoStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
                accountInfoStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16)
            ]
        )
        
        accountInfoStack.addArrangedSubviews([accountTitleLabel, accountBalanceLabel])
        
        self.view.add(
            subview: btcCurrencyLabel,
            with: [
                btcCurrencyLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
                btcCurrencyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: accountInfoStack.trailingAnchor, constant: 16),
                btcCurrencyLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
            ]
        )
        
        self.view.add(
            subview: buttonsStack,
            with: [
                buttonsStack.topAnchor.constraint(equalTo: accountInfoStack.bottomAnchor, constant: 24),
                buttonsStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
        
        buttonsStack.addArrangedSubviews([cashInButton, cashOutButton])
        
        self.view.add(
            subview: transactionsTableView,
            with: [
                transactionsTableView.topAnchor.constraint(equalTo: buttonsStack.bottomAnchor, constant: 32),
                transactionsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                transactionsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                transactionsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ]
        )
        
        self.view.add(
            subview: emptyView,
            with: [
                emptyView.topAnchor.constraint(equalTo: buttonsStack.bottomAnchor, constant: 32),
                emptyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                emptyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                emptyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ]
        )
    }
    
    // MARK: - Private methods
    @objc private func topUp(_ sender: UIButton) {
        transition(
            to: Route.topUp,
            as: .modal(presentationStyle: .overFullScreen, transitionStyle: .crossDissolve, animated: true)
        )
    }
    
    @objc private func newTransaction(_ sender: UIButton) {
        print("new transaction")
    }
    
    private func setupCurrencyInfo(with info: BTCCurrency?) {
        guard let info else {
            btcCurrencyLabel.text = "$ 97,300" /// set cached value or default value
            return
        }
        btcCurrencyLabel.text = "$ \(info.priceUsd.toRoundedDouble())"
    }
}
