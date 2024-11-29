import UIKit

// Вью курьера на хэдере главного экрана
final class CourierView: UIView {

    // MARK: - Properties
    private lazy var courierImageView = AppImageView(type: .courier)

    private let height: CGFloat = 40

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension CourierView {
    func setupUI() {
        backgroundColor = AppColors.backgroundGray
        layer.masksToBounds = true
        addSubviews(courierImageView)

        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: height),
            widthAnchor.constraint(equalTo: heightAnchor),

            courierImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            courierImageView.centerYAnchor.constraint(equalTo: centerYAnchor),     
        ])
    }
}
