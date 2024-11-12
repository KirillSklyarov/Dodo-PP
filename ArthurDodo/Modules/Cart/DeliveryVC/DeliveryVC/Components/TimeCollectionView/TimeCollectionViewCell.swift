import UIKit

final class TimeCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    static let identifier: String = "TimeCollectionViewCell"
    private let cornerRadius: CGFloat = 10

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semibold18
        label.textColor = .white
        label.text = "Побыстрее"
        label.textAlignment = .center
        return label
    }()

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
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
