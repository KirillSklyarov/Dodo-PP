import UIKit

final class CourierView: UIView {

    private lazy var courierImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "figure.hiking")?.withTintColor(AppColors.buttonOrange, renderingMode: .alwaysOriginal)
        return imageView
    }()

    private let height: CGFloat = 40

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
