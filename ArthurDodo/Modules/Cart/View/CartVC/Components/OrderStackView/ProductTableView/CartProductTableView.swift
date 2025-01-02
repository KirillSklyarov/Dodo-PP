import UIKit

final class CartProductTableView: AppTableView {

    // MARK: - Properties&Callbacks
    private let tableRowHeight: CGFloat = 160
    private var cart: Cart?

    var onUpdateCart: ( (Int) -> Void )?
    var onCellTapped: ( (Item) -> Void )?
    var onEmptyCart: ( () -> Void )?
    var onItemDeletedFromCart: ( (IndexPath) -> Void )?
    var onCountChanged: ( (IndexPath, Int) -> Void )?
    var onItemCellSelected: ( (CartItem) -> Void )?

    private var state: ScreenState = .loading

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
    func uploadCart(_ cart: Cart) {
        self.cart = cart
        orderLoaded()
        checkIfCartIsEmpty()
    }
}

// MARK: - Setup UI
private extension CartProductTableView {
    func configTableView() {
        dataSource = self
        delegate = self
        registerCell(CartProductCell.self)
        registerCell(SkeletonTableViewCell.self)
        separatorStyle = .singleLine
        separatorColor = AppColors.backgroundGray
        separatorInset = .zero
        rowHeight = tableRowHeight
        estimatedRowHeight = UITableView.automaticDimension

        backgroundColor = .clear
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CartProductTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .initial: return 1
        case .loading: return 1
        case .success: return cart?.items.count ?? 0
        case .error: return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .initial: return UITableViewCell()
        case .loading:
            let cell = tableView.dequeueCell(indexPath) as SkeletonTableViewCell
            return cell
        case .success:
            let cell = tableView.dequeueCell(indexPath) as CartProductCell
            guard let item = cart?.items[indexPath.row] else { print("Can't get item from Order"); return UITableViewCell()}

            cell.configureCell(cartItem: item)

            cell.onValueIsNull = { [weak self] in
                self?.removeItemFromStorage(indexPath)
            }

            cell.onStepperValueChanged = { [weak self] value in
                self?.onCountChanged?(indexPath, value)
            }
            return cell
            case .error: return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = cart?.items[indexPath.row] else { return }
        setSelection(item)
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
        guard let cart else {print("Cart is nil"); return }
        if cart.items.isEmpty {
            onEmptyCart?()
        } else {
            updateUI()
        }
    }

    // Меняем состояние экрана и обновляем его
    private func orderLoaded() {
        state = .success
        updateUI()
    }

    // Включает или отключает возможность выбора ячейки (если у продукта нет опций, то отключаем ему возможность выбора)
    func setSelection(_ item: CartItem) {
        if !item.isOneSize { onItemCellSelected?(item) }
    }

    // Обновляем UI
    func updateUI() {
        reloadData()
//        updateTableViewHeight()
    }

//    private var heightConstraint: NSLayoutConstraint?
//
//
//    func updateTableViewHeight() {
//        let tableViewHeight = contentSize.height
//
//        if let heightConstraint {
//            heightConstraint.constant = tableViewHeight
//        } else {
//            heightConstraint = heightAnchor.constraint(equalToConstant: tableViewHeight)
//            heightConstraint?.isActive = true
//        }
//    }
}
