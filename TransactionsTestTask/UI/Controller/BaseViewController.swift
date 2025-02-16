//
//  BaseViewController.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 16.02.2025.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    // MARK: - Bag
    
    var bag = Bag()
    
    // MARK: - Inits
    
    init() { super.init(nibName: nil, bundle: nil) }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor(.white)
        bind()
    }
    
    // MARK: - Bind
    
    func bind() { }

}
