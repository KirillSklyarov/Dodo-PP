import UIKit

final class SpecialOfferHeaderView: UICollectionReusableView {

    // MARK: - Properties
    private lazy var titleLabel = AppLabelDS(type: .name)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension SpecialOfferHeaderView {
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}

// MARK: - Setup UI
private extension SpecialOfferHeaderView {
    func configUI() {
        addSubviews(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
