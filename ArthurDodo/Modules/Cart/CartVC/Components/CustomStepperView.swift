import UIKit

// Степпер, который переключает кол-во единиц позиции в заказе
final class CustomStepperView: UIView {

    // MARK: - UI properties
    private lazy var decrementButton = AppButtons(type: .decrementCount)
    private lazy var incrementButton = AppButtons(type: .incrementCount)
    private lazy var valueLabel = AppLabel(type: .smallTitle, text: "\(value)")

    private lazy var contentStack = AppStackView([decrementButton, valueLabel, incrementButton], axis: .horizontal, distribution: .fillEqually)

    // MARK: - Properties
    private let viewHeight: CGFloat = 25
    private let viewWidth: CGFloat = 90
    private let cornerRadius: CGFloat = 10

    private var value: Int = 0 {
        didSet {
            if value < 0 { value = 0 }
            valueLabel.text = "\(value)"
        }
    }

    var onValueIsNull: (() -> Void)?
    var onStepperValueChanged: ( (Int) -> Void)?

    // MARK: - Init
    init(frame: CGRect = .zero, isHidden: Bool = false) {
        super.init(frame: frame)
        setupUI()
        setupActions()
        self.isHidden = isHidden
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func setStepperValue(_ value: Int) {
        self.value = value
    }
}

// MARK: - Setup Actions
private extension CustomStepperView {
    func setupActions() {
        setupDecrementButtonAction()
        setupIncrementButtonAction()
    }

    func setupDecrementButtonAction() {
        decrementButton.onButtonTapped = { [weak self] in
            self?.decrementButtonTapped()
        }
    }

    func setupIncrementButtonAction() {
        incrementButton.onButtonTapped = { [weak self] in
            self?.incrementButtonTapped()
        }
    }
}


// MARK: - Setup UI
private extension CustomStepperView {
    func setupUI() {
        valueLabel.textAlignment = .center

        backgroundColor = AppColors.buttonGray
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        addSubviews(contentStack)
        setupLayout()
    }

    func setupLayout() {
        contentStack.setConstraints()
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: viewHeight),
            widthAnchor.constraint(equalToConstant: viewWidth)
        ])
    }
}

// MARK: - Supporting methods
private extension CustomStepperView {
    // Уменьшаем кол-во и проверяем если осталось 0, от вызываем коллбэк (он должен будет удалить позицию), если нет, то вызываем другой коллбэк
    func decrementButtonTapped() {
        value -= 1
        if value == 0 {
            onValueIsNull?()
        } else {
            onStepperValueChanged?(value)
        }
    }

    func incrementButtonTapped() {
        value += 1
        onStepperValueChanged?(value)
    }
}
