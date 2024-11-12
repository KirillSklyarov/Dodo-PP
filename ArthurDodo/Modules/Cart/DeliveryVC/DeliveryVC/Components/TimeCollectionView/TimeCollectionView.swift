import UIKit

final class TimeCollectionView: UICollectionView {

    // MARK: - Properties
    private let numberOfItems = 4
    private let collectionHeight: CGFloat = 50

    private var timeIntervals: [String] = []

    var onDeliveryTimeSelected: ((String) -> Void)?

    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        super.init(frame: frame, collectionViewLayout: collectionLayout)

        getDeliveryTimeintervals()
        setupCollection()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension TimeCollectionView {
    func setupCollection() {
        dataSource = self
        delegate = self
        register(TimeCollectionViewCell.self, forCellWithReuseIdentifier: TimeCollectionViewCell.identifier)
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false

        selectFirstCell()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension TimeCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeCollectionViewCell.identifier, for: indexPath) as? TimeCollectionViewCell else { return UICollectionViewCell() }
        let cellTime = timeIntervals[indexPath.row]

        cell.configureCell(cellTime)

        designSelectedCell(cell)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        designSelectedCell(collectionView, indexPath)
        let timeInterval = timeIntervals[indexPath.row]
        onDeliveryTimeSelected?(timeInterval)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2.5
        return CGSize(width: width, height: collectionHeight)
    }
}

// MARK: - Supporting methods
private extension TimeCollectionView {
    // Получаем временные интервалы доставки из хелпера
    func getDeliveryTimeintervals() {
        timeIntervals = DeliveryTimeIntervalHelper.setupTimeInterval()
    }

    // Делаем выбранной первую ячейку
    func selectFirstCell() {
        let firstItemIndexPath = IndexPath(row: 0, section: 0)
        selectItem(at: firstItemIndexPath, animated: false, scrollPosition: .left)
    }

    // Если ячейка выбрана, то у нее есть рамка, если не выбрана, то рамки нет
    func designSelectedCell(_ cell: TimeCollectionViewCell) {
        if cell.isSelected {
            cell.layer.borderWidth = 2
        } else {
            cell.layer.borderWidth = 0
        }
    }

    private func designSelectedCell(_ collectionView: UICollectionView,
                                    _ indexPath: IndexPath) {
        selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2
    }
}
