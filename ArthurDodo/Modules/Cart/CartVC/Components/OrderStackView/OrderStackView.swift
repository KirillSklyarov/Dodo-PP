import UIKit

final class OrderStackView: UIStackView {

    // MARK: - Properties
    private lazy var orderView = OrderView() // Плашка с кол-вом товара и общей суммой
    private lazy var cartProductTableView = CartProductTableView() // Таблица с товарами в корзине

    var onEmptyCart: (() -> Void)?
    var onItemDeletedFromCart: ((IndexPath) -> Void)?
    var onCountChanged: ((IndexPath, Int) -> Void)?
    var onChangeItem: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension OrderStackView {
    // Получаем актуальную корзину от VC
    func getCart(_ cart: Cart) {
        passCartToView(cart)
    }

    // Оправляем актуальный заказ для отражения в таблицу
    private func passCartToView(_ cart: Cart) {
        cartProductTableView.uploadCart(cart)
    }

    // При изменении кол-ва и общей цены обновляем заголовок
    func updateHeader(_ countOfItems: Int, totalPrice: Int) {
        orderView.updateTitle(countOfItems, totalPrice: totalPrice)
    }
}

// MARK: - Setup UI
private extension OrderStackView {
    func setupUI() {
        [orderView, cartProductTableView].forEach(addArrangedSubview)
        axis = .vertical
        spacing = 10
    }
}

// MARK: - Setup Actions
private extension OrderStackView {
    func setupActions() {
        // Отправляем инфу, что товаров в заказе нет и нужно закрыть окно
        cartProductTableView.onEmptyCart = { [weak self] in
            self?.onEmptyCart?()
        }

        // Отправляем инфу, что удалили позицию на VC
        cartProductTableView.onItemDeletedFromCart = { [weak self] indexPath in
            self?.onItemDeletedFromCart?(indexPath)
        }

        // Отправляем инфу, что изменили кол-во товара на VC
        cartProductTableView.onCountChanged = { [weak self] indexPath, count in
            self?.onCountChanged?(indexPath, count)
        }

        // Отправляем инфу, что изменили сам товар на VC
        cartProductTableView.onChangeItem = { [weak self] in
            self?.onChangeItem?()
        }
    }
}
