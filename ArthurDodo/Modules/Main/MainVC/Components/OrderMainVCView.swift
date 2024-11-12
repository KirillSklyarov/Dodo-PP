import UIKit

final class OrderMainVCView: UIView {

    // MARK: - Properties
    private let viewHeight: CGFloat = 100
    private let cartImageViewSize: CGFloat = 60
    private let cornerRadius: CGFloat = 10

    private var viewHeightConstraint: NSLayoutConstraint?

    // MARK: - UI Properties
    private lazy var cartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cart.circle")?.withTintColor(AppColors.grayFont, renderingMode: .alwaysOriginal)
        imageView.heightAnchor.constraint(equalToConstant: cartImageViewSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: cartImageViewSize).isActive = true
        return imageView
    }()
    private lazy var cartImageContainerView: UIView = {
        let view = UIView()
        view.addSubviews(cartImageView)
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColors.grayFont
        label.font = AppFonts.semibold18
        return label
    }()
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColors.grayFont
        label.font = AppFonts.semibold18
        return label
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColors.backgroundBlack
        label.font = AppFonts.bold20
        label.backgroundColor = .systemYellow
        label.textAlignment = .center
        label.layer.cornerRadius = cornerRadius
        label.layer.masksToBounds = true
        label.heightAnchor.constraint(equalToConstant: viewHeight / 2).isActive = true
        return label
    }()
    private lazy var timeView: UIView = {
        let view = UIView()
        view.addSubviews(timeLabel)
        return view
    }()
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [UIView(), titleLabel, statusLabel, UIView()])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        return stackView
    }()
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cartImageContainerView, textStackView, timeView, UIView()])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()

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
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func setupElementsLayout() {
        NSLayoutConstraint.activate([
            cartImageContainerView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, multiplier: 0.25),

            cartImageView.centerXAnchor.constraint(equalTo: cartImageContainerView.centerXAnchor),
            cartImageView.centerYAnchor.constraint(equalTo: cartImageContainerView.centerYAnchor),

            timeLabel.centerXAnchor.constraint(equalTo: timeView.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: timeView.centerYAnchor),
            timeView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, multiplier: 0.28),

            timeLabel.widthAnchor.constraint(equalTo: timeView.widthAnchor, multiplier: 0.87),
        ])
    }
}
