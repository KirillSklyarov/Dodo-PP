import UIKit

final class ContentStackView: UIStackView {

    private lazy var orderView = OrderMainVCView()
    private lazy var contentCollectionView = ContentCollectionView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ContentStackView {
    func setupUI() {
        addArrangedSubview(contentCollectionView)
    }
}
