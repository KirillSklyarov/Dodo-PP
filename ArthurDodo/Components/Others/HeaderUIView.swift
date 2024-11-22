import UIKit

final class HeaderView: UIView {

    // MARK: - Properties
    private let imageSize: CGFloat = 30
    private let buttonSize: CGFloat = 30

    private let topInset: CGFloat = 10
    private let leftInset: CGFloat = 20
    private let rightInset: CGFloat = -20
    private let bottomInset: CGFloat = -5

    var onProfileButtonTapped: (() -> Void)?
    var onAddressTapped: (() -> Void)?

    // MARK: - UI Properties
    private lazy var courierImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "figure.walk.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        return imageView
    }()
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Укажите адрес доставки"
        label.textColor = .white
        return label
    }()
    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return imageView
    }()
    private lazy var addressStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [courierImageView, addressLabel, chevronImageView])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addressTapped))
        stackView.addGestureRecognizer(tapGesture)
        return stackView
    }()
    private lazy var profileButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "person.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addressStackView, UIView(), profileButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
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
extension HeaderView {
    func updateAddress(_ address: String) {
        addressLabel.text = address
    }
}

// MARK: - Setup button actions
private extension HeaderView {
    @objc func profileButtonTapped() {
        onProfileButtonTapped?()
    }

    @objc func addressTapped() {
        onAddressTapped?()
    }
}

// MARK: - Setup UI
private extension HeaderView {
    func setupUI() {
        addSubviews(contentStackView)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInset),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightInset),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomInset)
        ])
    }
}
