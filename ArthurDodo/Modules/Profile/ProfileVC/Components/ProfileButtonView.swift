import UIKit

final class ProfileButtonView: UIView {

    // MARK: - UI Properties
    private lazy var myButton = AppButton(imageColor: .white, target: self, action: #selector(myButtonTapped))

    // MARK: - Properties
    private let viewSize: CGFloat = 40
    var onButtonTapped: (() -> Void)?

    // MARK: - Init
    init(frame: CGRect = .zero, type: Button) {
        super.init(frame: frame)
        configUI()
        myButton.setImage(type: type, imageColor: .white)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - IB Actions
    @objc private func myButtonTapped() {
        onButtonTapped?()
    }

    // MARK: - Private methods
    private func configUI() {
        backgroundColor = AppColors.backgroundGray

        heightAnchor.constraint(equalToConstant: viewSize).isActive = true
        widthAnchor.constraint(equalToConstant: viewSize).isActive = true

        layer.cornerRadius = viewSize / 2
        layer.masksToBounds = true

        addSubviews(myButton)

        setupLayout()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            myButton.topAnchor.constraint(equalTo: topAnchor),
            myButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            myButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            myButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
