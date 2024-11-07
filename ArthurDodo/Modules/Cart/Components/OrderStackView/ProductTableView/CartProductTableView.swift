import UIKit

final class CartProductTableView: AppTableView {

    // MARK: - Properties&Callbacks
    private let tableRowHeight: CGFloat = 160
    private var heightConstraint: NSLayoutConstraint?

    var order: [Order] = []
    var onUpdateCart: ( (Int) -> Void )?
    var onCellTapped: ( (Item) -> Void )?
    var onEmptyCart: ( () -> Void )?
    var onItemDeletedFromCart: ( (IndexPath) -> Void )?
    var onCountChanged: ( (IndexPath, Int) -> Void )?
    var onChangeItem: ( () -> Void )?

    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Fetch data
extension CartProductTableView {
    // Получаем актуальный заказ от VC и обновляем UI
    func uploadOrder(_ order: [Order]) {
        self.order = order
        checkIfCartIsEmpty()
    }
}

// MARK: - Setup UI
private extension CartProductTableView {
     func configTableView() {
        dataSource = self
        delegate = self
        register(CartProductCell.self, forCellReuseIdentifier: CartProductCell.identifier)
        separatorStyle = .singleLine
        separatorColor = AppColors.backgroundGray
        separatorInset = .zero
        rowHeight = tableRowHeight
        estimatedRowHeight = UITableView.automaticDimension

        backgroundColor = .clear
    }

    func updateTableViewHeight() {
        let tableViewHeight = contentSize.height

       if let heightConstraint {
           heightConstraint.constant = tableViewHeight
       } else {
           heightConstraint = heightAnchor.constraint(equalToConstant: tableViewHeight)
           heightConstraint?.isActive = true
       }
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
        cell.configureCell(itemInOrder: item)

        cell.onValueIsNull = { [weak self] in
            self?.removeItemFromStorage(indexPath)
        }

        cell.onChangeButtonTapped = { [weak self] in
            self?.onChangeItem?()
        }

        cell.onStepperValueChanged = { [weak self] value in
            self?.onCountChanged?(indexPath, value)
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

    // Отправляем инфу, что удалили позицию
    private func removeItemFromStorage(_ indexPath: IndexPath) {
        onItemDeletedFromCart?(indexPath)
    }
}

// MARK: - Supporting methods
private extension CartProductTableView {
    // Запускаем информацию о закрытии окна, если заказов нет или обновляем UI если заказы есть
    func checkIfCartIsEmpty() {
        if order.isEmpty {
            onEmptyCart?()
        } else {
            updateUI()
        }
    }

    // Обновляем UI
    func updateUI() {
        reloadData()
        updateTableViewHeight()
    }
}
