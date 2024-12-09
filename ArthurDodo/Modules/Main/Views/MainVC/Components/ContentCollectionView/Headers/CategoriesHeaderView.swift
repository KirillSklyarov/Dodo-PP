import UIKit

final class CategoriesHeaderView: UICollectionReusableView {

    // MARK: - UI Properties
    private lazy var headerCollectionView = CategoryHeaderCollectionView()

    // MARK: - Properties
    private let viewHeight: CGFloat = 40
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10

    var onCategorySelected: ((Category) -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        collectionCellSelected()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI() {
        headerCollectionView.updateUI()
    }

    func passCategories(_ categories: [Category]) {
        headerCollectionView.getCategories(categories)
    }

    func getCategory(_ categoryName: String) {
        headerCollectionView.selectCat(categoryName)
    }

    func collectionCellSelected() {
        headerCollectionView.onUpdateProductsCollectionView = { [weak self] categoryName in
            self?.onCategorySelected?(categoryName)
        }
    }

    // MARK: - Private methods
    private func setupConstraints() {
        addSubviews(headerCollectionView)
        headerCollectionView.setConstraints()
    }
}
