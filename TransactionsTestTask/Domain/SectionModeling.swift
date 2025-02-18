//
//  SectionModeling.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 18.02.2025.
//

import Foundation

protocol SectionModeling {
    var headerTitle: String { get }
    var cellModels: [CellModeling] { get }
}
