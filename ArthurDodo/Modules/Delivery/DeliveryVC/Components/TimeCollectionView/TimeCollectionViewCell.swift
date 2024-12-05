import UIKit

final class TimeCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    private lazy var timeLabel = AppLabel(type: .maxiTitle, text: "Побыстрее")

    private let cornerRadius: CGFloat = 10

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(_ timeInterval: String) {
        timeLabel.text = timeInterval
    }
}

// MARK: - Setup UI
private extension TimeCollectionViewCell {
    func setupUI() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        backgroundColor = AppColors.backgroundGray
        layer.borderColor = AppColors.buttonOrange.cgColor
        contentView.addSubviews(timeLabel)

        setupLayout()
    }

    func setupLayout() {
        timeLabel.setConstraints()
    }
}
