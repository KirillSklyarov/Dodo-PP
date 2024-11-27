import UIKit

final class OrderMainVCView: UIView {

    // MARK: - UI Properties
    private lazy var cartImageView = AppImageView(viewImage: AppImages.common(.cartCircle), tintColor: .grayFont)
    private lazy var titleLabel = AppLabel(textColor: .grayFont, font: .semibold(size: 18))
    private lazy var statusLabel = AppLabel(textColor: .grayFont, font: .semibold(size: 18))

    private lazy var timeLabel: AppLabel = {
        let label = AppLabel(textColor: .backgroundBlack, font: .bold(size: 20))
        label.textAlignment = .center
        label.layer.cornerRadius = cornerRadius
        label.backgroundColor = .systemYellow
        label.clipsToBounds = true
        return label
    }()

    private lazy var textStackView = AppStackView([titleLabel, statusLabel], axis: .vertical, spacing: 0, alignment: .leading, distribution: .fillEqually)
    private lazy var contentStackView = AppStackView([cartImageView, textStackView, timeLabel], axis: .horizontal, spacing: 0, alignment: .center, distribution: .equalSpacing)

    // MARK: - Properties
    private let viewHeight: CGFloat = 100
    private let cornerRadius: CGFloat = 10
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10

    private var viewHeightConstraint: NSLayoutConstraint?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension OrderMainVCView {
    // Если активный заказ есть, то высота хорошая, если нет заказа, то 0
    func calculateHeight(_ isOrder: Bool) {
        viewHeightConstraint?.constant = isOrder ? viewHeight : 0
    }

    func getOrder(_ order: Order, _ totalPrice: Int) {
        updateUI(with: order, totalPrice)
    }
}

// MARK: - Supporting methods
private extension OrderMainVCView {
    // Обновляем все лейблы
    func updateUI(with order: Order, _ totalPrice: Int) {
        titleLabel.text = "Заказ на \(totalPrice) ₽"
        statusLabel.text = order.status.rawValue
        updateTimeLabel(order)
    }

    // Показываем правильно время доставки
    func updateTimeLabel(_ order: Order) {
        var correctTime = "30 мин"
        if order.deliveryTime != "" {
            if let timeText = order.deliveryTime?.components(separatedBy: "-").last?.dropFirst() {
                correctTime = "\(timeText)"
            }
        }
        timeLabel.text = "~\(correctTime)"
    }
}

// MARK: - Setup UI
private extension OrderMainVCView {
    func setupUI() {
        backgroundColor = AppColors.backgroundGray
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        setBorder(AppColors.buttonOrange)

        addSubviews(contentStackView)

        setupLayout()
    }
}

// MARK: - Setup Layout
private extension OrderMainVCView {
    func setupLayout() {
        viewHeightConstraint = heightAnchor.constraint(equalToConstant: viewHeight)
        viewHeightConstraint?.isActive = true

        setupContentStackViewLayout()
        setupElementsLayout()
    }

    func setupContentStackViewLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func setupElementsLayout() {
        NSLayoutConstraint.activate([
            cartImageView.heightAnchor.constraint(equalTo: contentStackView.heightAnchor, multiplier: 0.75),
            cartImageView.widthAnchor.constraint(equalTo: cartImageView.heightAnchor),

            timeLabel.heightAnchor.constraint(equalTo: contentStackView.heightAnchor, multiplier: 0.5),
            timeLabel.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, multiplier: 0.28),
        ])
    }
}
