import UIKit

// Блок на экране с ингредиентами, весом и экраном с КБЖУ
final class IngredientsView: UIView {

    // MARK: - UI Properties
    private lazy var ingredientsLabel = AppLabel(type: .basicTitle)
    private lazy var infoButton = AppButtons(type: .infoButton)
    private lazy var weightLabel = AppLabel(type: .basicTitle)

    private lazy var ingredientsAndInfoStack = AppStackView([ingredientsLabel, infoButton], axis: .horizontal, spacing: 10, alignment: .leading)

    private lazy var contentStack = AppStackView([ingredientsAndInfoStack, weightLabel], axis: .vertical, spacing: 10)

    private lazy var cpfcPopupView = CpfcPopupView(item: item)

    // MARK: - Properties&Callbacks
    private let cornerRadius: CGFloat = 10

    private var item: Item?

    var onShowPopupVC: ((CpfcPopupView) -> Void)?

    // MARK: - Init
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension IngredientsView {
    // Получаем выбранный товар
    func getSelectedItem(_ item: CartItem) {
        self.item = item.item
        updateUI(item)
    }

    func getSelectedItem(_ item: Item) {
        cpfcPopupView.getItem(item)
    }

    // Обновляем данные о составе товара
    func updateIngredients(_ ingredients: String) {
        ingredientsLabel.text = ingredients
    }

    // Обновляем данные о весе товара
    func updateWeight(_ weight: Int) {
        let text = "\(weight) г"
        weightLabel.text = text
    }

    // Обновляем данные для таблицы КБЖУ
    func setProductDetails(_ details: WeightPrice) {
        cpfcPopupView.setProductDetails(details)
    }
}

// MARK: - Setup UI
private extension IngredientsView {
    func setupUI() {
        backgroundColor = AppColors.buttonGray
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        addSubviews(contentStack)

        setupLayout()
    }

    func setupLayout() {
        contentStack.setConstraints(allInsets: 10)
    }
}

// MARK: - Setup actions
private extension IngredientsView {
    func setupActions() {
        setupInfoButtonAction()
    }

    func setupInfoButtonAction() {
        infoButton.onButtonTapped = { [weak self] in
            self?.showPopupView()
        }
    }
}

// MARK: - Setup PopUpIngredientsView
 extension IngredientsView {
    func showPopupView() {
        setupPopupView()
        onShowPopupVC?(cpfcPopupView)
    }

    // Настраиваем откуда будет показываться экран и кто его источник (т.е. на какой вьюхе он будет показываться)
    func setupPopupView() {
        let sourceRect = CGRect(
            origin: CGPoint(x: infoButton.frame.minX + 10,
                            y: infoButton.frame.midY + 10),
            size: .zero)
        cpfcPopupView.setupPopupView(sourceView: self, sourceRect: sourceRect)
    }
}

// Настройка что экран должен показываться в стиле Popover
extension IngredientsView: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}

// MARK: - Supporting methods
private extension IngredientsView {
    // Обновляем UI: окно с КБЖУ и вес во view
    func updateUI(_ item: CartItem) {
        cpfcPopupView.getItem(item.item)
        let selectedWeight = item.weight
        updateWeight(selectedWeight)
    }
}
