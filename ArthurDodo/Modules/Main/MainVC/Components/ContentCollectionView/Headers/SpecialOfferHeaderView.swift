import UIKit

final class SpecialOfferHeaderView: UICollectionReusableView {

    // MARK: - Properties
    private lazy var titleLabel = AppLabel(type: .name)

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
        titleLabel.setConstraints()
    }
}
