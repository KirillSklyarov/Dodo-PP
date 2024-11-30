import UIKit

final class InfoAndToppingsView: UIView {

    // MARK: - Properties
    private lazy var infoAndToppingsStack = InfoAndToppingsStack()

    var onShowPopupVC: ((UIViewController) -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension InfoAndToppingsView {
    // Передаем выбранный товар дальше
    func getSelectedItem(_ item: Item) {
        infoAndToppingsStack.getSelectedItem(item)
    }

    func getCartView(_ cart: AppCartButtonView) {
        infoAndToppingsStack.getButtonView(cart)
    }

    // Отправляем данные о выбранных деталях (вес, КБЖУ и проч) выбранного товара
    func updateUI(productDetails: WeightPrice) {
        infoAndToppingsStack.updateUI(productDetails: productDetails)
    }

    // Обновляем данные о весе товара
    func updateWeight(_ weight: Int) {
        infoAndToppingsStack.updateWeight(weight)
    }

    // Обновляем данные о весе товара и составе
    func updateIngredientsAndWeight(_ item: Item) {
        infoAndToppingsStack.updateUIWithItem(item)
    }

    // Отправляем данные о топпингов дальше ко вью
    func passToppingsToView(_ toppings: [Topping]) {
        infoAndToppingsStack.passToppingsToView(toppings)
    }
}

// MARK: - Setup actions
private extension InfoAndToppingsView {
    func setupActions() {
        setupInfoButtonAction()
    }

    func setupInfoButtonAction() {
        infoAndToppingsStack.onShowPopupVC = { [weak self] popupVC in
            self?.onShowPopupVC?(popupVC)
        }
    }
}

// MARK: - Setup UI
private extension InfoAndToppingsView {
    func setupUI() {
        addSubviews(infoAndToppingsStack)
        setupLayout()
    }

    func setupLayout() {
        infoAndToppingsStack.setConstraints(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    }
}
