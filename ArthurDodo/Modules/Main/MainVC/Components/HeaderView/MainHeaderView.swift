import UIKit

final class MainHeaderView: UIView {

    // MARK: - UI Properties
    private lazy var courierView = CourierView()

    private lazy var addressLabel = AppLabel(text: "Укажите адрес доставки", textColor: .white, font: .regular(size: 14))
    private lazy var deliveryTimeLabel = AppLabel(text: "около 40 минут", textColor: .sberGreen, font: .regular(size: 12))
    private lazy var chevronImageView = AppImageView(viewImage: .main(.chevronDown), tintColor: .white)

    private lazy var profileContainerView: ProfileMainHeaderView = {
        let view = ProfileMainHeaderView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileButtonTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()

    private lazy var addressNameStackView = AppStackView([addressLabel, chevronImageView], axis: .horizontal, spacing: 5)
    private lazy var labelStackView = AppStackView([addressNameStackView, deliveryTimeLabel], axis: .vertical, spacing: 0, alignment: .leading)
    private lazy var addressStackView: AppStackView = {
        let stackView = AppStackView([courierView, labelStackView], axis: .horizontal, spacing: 20)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addressTapped))
        stackView.addGestureRecognizer(tapGesture)
        return stackView
    }()
    private lazy var contentStackView = AppStackView([addressStackView, UIView(), profileContainerView], axis: .horizontal, spacing: 10)

    // MARK: - Properties
    private let topInset: CGFloat = 10
    private let leftInset: CGFloat = 20
    private let rightInset: CGFloat = -20
    private let bottomInset: CGFloat = -5

    var onProfileButtonTapped: (() -> Void)?
    var onAddressTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        isUIVisible(false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        courierView.layer.cornerRadius = contentStackView.frame.height / 2
    }
}

// MARK: - Public methods
extension MainHeaderView {
    // Обновление всех UI на вью
    func updateUI(_ address: String, _ coins: Int) {
        updateAddress(address)
        updateProfileCoins(coins)
    }

    // Обновляем название адреса (Дом, офис и тп)
    private func updateAddress(_ address: String) {
        addressLabel.text = address
        isUIVisible(true)
    }

    // Обновляем кол-во монет на профиле
    private func updateProfileCoins(_ coins: Int) {
        profileContainerView.updateCoinsLabel(with: coins)
    }
}

// MARK: - Setup button actions
private extension MainHeaderView {
    @objc func profileButtonTapped() {
        onProfileButtonTapped?()
    }

    @objc func addressTapped() {
        onAddressTapped?()
    }
}

// MARK: - Setup UI
private extension MainHeaderView {
    func setupUI() {
        addSubviews(contentStackView)
        setupLayout()
    }

    func setupLayout() {
        contentStackViewLayout()
    }

    func contentStackViewLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInset),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightInset),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomInset),
            courierView.widthAnchor.constraint(equalTo: courierView.heightAnchor)
        ])
    }
}

// MARK: - Supporting methods
private extension MainHeaderView {
    // Показываем или скрываем все UI элементы на вьюхе (нужно в процессе загрузки экрана)
    func isUIVisible(_ isVisible: Bool) {
        [addressLabel, chevronImageView, deliveryTimeLabel, courierView, profileContainerView].forEach { $0.isHidden = !isVisible }
    }
}
