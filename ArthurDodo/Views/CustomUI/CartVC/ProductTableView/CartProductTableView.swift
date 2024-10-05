//
//  CartProductTableView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 24.09.2024.
//

import UIKit

final class CartProductTableView: UITableView {

    // MARK: - Properties&Callbacks
    var order: [Order] = []
    var onUpdateCart: ( (Int) -> Void )?
    var onCellTapped: ( (Pizza) -> Void )?
    var onEmptyCart: ( () -> Void )?
    var onItemDeletedFromCart: ( () -> Void )?
    var onCountIncreased: ( () -> Void )?
    var onChangeItem: ( () -> Void )?

    private let tableRowHeight: CGFloat = 160
    private var tableViewHeight: CGFloat = 0
    private var heightConstraint: NSLayoutConstraint?

    private let dataStorage = OrderDataStorage.shared

    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configTableView()
        uploadOrder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func uploadOrder() {
        order = dataStorage.getOrderFromStorage()
        updateTableViewHeight()
        reloadData()
    }

    // MARK: - Private methods
    private func updateTableViewHeight() {
        tableViewHeight = CGFloat(order.count) * tableRowHeight

        if let heightConstraint {
            heightConstraint.constant = tableViewHeight
        } else {
            heightConstraint = heightAnchor.constraint(equalToConstant: tableViewHeight)
            heightConstraint?.isActive = true
        }
    }

    private func configTableView() {
        dataSource = self
        delegate = self
        register(CartProductCell.self, forCellReuseIdentifier: CartProductCell.identifier)
        separatorStyle = .singleLine
        separatorColor = .systemRed
        rowHeight = tableRowHeight
        estimatedRowHeight = UITableView.automaticDimension

        backgroundColor = .clear
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CartProductTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        order.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartProductCell.identifier, for: indexPath) as? CartProductCell else { print("rrrr"); return UITableViewCell() }
        let item = order[indexPath.row]
        cell.configureCell(pizzaInOrder: item)

        cell.onValueIsNull = { [weak self] in
            self?.removeItemFromStorage(indexPath)
        }

        cell.onChangeButtonTapped = { [weak self] in
            self?.onChangeItem?()
        }

        cell.onStepperValueChanged = { [weak self] value in
            self?.dataStorage.increaseCountOfItem(indexPath, value)
            self?.uploadOrder()
            self?.onCountIncreased?()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _,_,_ in
            guard let self else { return }
            removeItemFromStorage(indexPath)
        }
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }

    // Удаляем с хранилища позицию заказа, обновляем таблицу
    private func removeItemFromStorage(_ indexPath: IndexPath) {
        dataStorage.removeItemFromOrderStorage(indexPath)
        uploadOrder()
        dismissOrRefreshCart()
    }

    // Здесь либо закрывается окно (если корзина пустая), либо удаляется позиция
    private func dismissOrRefreshCart() {
        if order.isEmpty {
            onEmptyCart?()
        } else {
            onItemDeletedFromCart?()
        }
    }
}
