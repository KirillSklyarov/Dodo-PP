import UIKit

// Блок на экране с ингредиентами, весом и экраном с КБЖУ
final class IngredientsView: UIView {

    // MARK: - UI Properties
    private lazy var ingredientsLabel = AppLabel(type: .name)
    private lazy var infoButton = AppButtons(type: .infoButton)
//    InfoButton()
    private lazy var weightLabel = AppLabel(type: .name)

    private lazy var ingredientsAndInfoStack = AppStackView([ingredientsLabel, infoButton], axis: .horizontal, spacing: 10, alignment: .leading)

    private lazy var contentStack = AppStackView([ingredientsAndInfoStack, weightLabel], axis: .vertical, spacing: 10)

    private lazy var cpfcPopupView = CpfcPopupView(item: item)

    // MARK: - Properties&Callbacks
    private let cornerRadius: CGFloat = 10
    private let topInset: CGFloat = 10
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let bottomInset: CGFloat = -10

    private var item: Item?

    var onShowPopupVC: ((UIViewController) -> Void)?

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
    func getSelectedItem(_ item: Item) {
        self.item = item
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
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInset),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightInset),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomInset)
        ])
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
            origin: CGPoint(x: infoButton.frame.minX - rightInset,
                            y: infoButton.frame.midY + topInset),
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
