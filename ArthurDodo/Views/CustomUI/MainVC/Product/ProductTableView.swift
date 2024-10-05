//
//  ProductTableView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 18.09.2024.
//

import UIKit

final class ProductTableView: UITableView {

    // MARK: - Properties&Callbacks
    var products: [FoodItems] = []
    var onUpdateCart: ( (Int) -> Void )?
    var onCellTapped: ( (FoodItems) -> Void )?

    private let cellHeight: CGFloat = 150
    private var heightConstraint: NSLayoutConstraint?

    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func calculateTableHeight() {
        let tableHeight = CGFloat(products.count) * cellHeight
        if let heightConstraint  {
            heightConstraint.constant = tableHeight
        } else {
            heightConstraint = heightAnchor.constraint(equalToConstant: tableHeight)
            heightConstraint?.isActive = true
        }
    }

    private func configTableView() {
        backgroundColor = .clear
        dataSource = self
        delegate = self
        register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        separatorStyle = .none
        rowHeight = cellHeight
        isScrollEnabled = false
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ProductTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as? ProductTableViewCell else { return UITableViewCell() }
        let pizza = products[indexPath.row]
        cell.configureCell(pizza: pizza)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pizza = products[indexPath.row]
        onCellTapped?(pizza)
    }
}
