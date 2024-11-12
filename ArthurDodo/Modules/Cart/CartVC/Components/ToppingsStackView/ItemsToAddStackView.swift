import UIKit

final class ItemsToAddStackView: UIStackView {

    // MARK: - UI Properties
    private lazy var itemsToAddHeader = OrderView(title: "Добавить к заказу?")
    private lazy var itemsToAddCollectionView = AddToCartCollectionView()
    private var itemsToAdd: [Item] = []

    var onNewItemToAddToCart: ((Order) -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Получаем товары, для отражения в корзине в категории "Добавить к заказу"
    func getItemsToAdd(_ items: [Item]) {
        itemsToAdd = items
        sendItemToAdd()
    }

    // Отправляем товары для отражения в категории "Добавить к заказу" далее по вьюхе
    private func sendItemToAdd() {
        itemsToAddCollectionView.getItemsToAddToOrder(itemsToAdd)
    }

    // Устанавливаем состояние экрана в коллекции
    func setState(_ state: ScreenState) {
        itemsToAddCollectionView.setState(state)
    }
}

// MARK: - Setup UI
private extension ItemsToAddStackView {
    func setupUI() {
        addArrangedSubview(itemsToAddHeader)
        addArrangedSubview(itemsToAddCollectionView)
        axis = .vertical
        spacing = 10
    }
}

// MARK: - Setup Actions
private extension ItemsToAddStackView {
    func setupActions() {
        itemsToAddCollectionView.onNewItemToAddToCart = { [weak self] itemToAddToOrder in
            self?.onNewItemToAddToCart?(itemToAddToOrder)
        }
    }
}
