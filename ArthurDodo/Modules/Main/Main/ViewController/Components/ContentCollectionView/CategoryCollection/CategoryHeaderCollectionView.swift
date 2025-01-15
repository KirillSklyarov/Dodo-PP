import UIKit

final class CategoryHeaderCollectionView: UICollectionView {

    // MARK: - Properties
    private var previousInd = IndexPath(row: 0, section: 0)
    private lazy var categories: [Category] = []

    var onUpdateProductsCollectionView: ( (Category) -> Void )?

    // MARK: - Init
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionHeadersPinToVisibleBounds = true
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        super.init(frame: .zero, collectionViewLayout: layout)
        configCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension CategoryHeaderCollectionView {
    func getCategories(_ categories: [Category]) {
        self.categories = categories
    }

    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }

    func selectCat(_ categoryName: String) {
        for (index, cat) in categories.enumerated() where cat.rawValue == categoryName {
            let indexPath = IndexPath(row: index, section: 0)
            selectCell(indexPath)
        }
    }
}

// MARK: - Setup UI
private extension CategoryHeaderCollectionView {
    func configCollectionView() {
        backgroundColor = AppColors.backgroundGray
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
        showsHorizontalScrollIndicator = false
        registerCell(CategoryViewCell.self)
        dataSource = self
        delegate = self
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension CategoryHeaderCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(indexPath) as CategoryViewCell
        let title = categories[indexPath.row].rawValue
        cell.configHeader(title, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCell(indexPath)
        let categoryName = categories[indexPath.row]
        onUpdateProductsCollectionView?(categoryName)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell else { return }
        cell.setTitleColor(.darkGray.withAlphaComponent(0.4))
    }
}

// MARK: - Supporting methods
private extension CategoryHeaderCollectionView {
    func designChosenCategory(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell else { print("Hey2"); return }
        cell.setTitleColor(.white)
    }

    func deSelectPreviousCell() {
        if let previousCell = cellForItem(at: previousInd) as? CategoryViewCell {
            previousCell.setTitleColor(AppColors.grayFont)
        }
    }

    func selectCell(_ indexPath: IndexPath) {
        deSelectPreviousCell()
        if let cell = cellForItem(at: indexPath) as? CategoryViewCell {
            selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            cell.setTitleColor(.white)
            setPreviousInd(indexPath)
        }
    }

    func setPreviousInd(_ indexPath: IndexPath)  {
        previousInd = indexPath
    }
}
