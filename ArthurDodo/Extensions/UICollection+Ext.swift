import UIKit

extension UICollectionView {
    // Получаем все видимые элементы в заданной области
    func indexPathsForVisibleItemsInRect(_ rect: CGRect) -> [IndexPath]? {
        let layoutAttributes = self.collectionViewLayout.layoutAttributesForElements(in: rect)
        return layoutAttributes?.map { $0.indexPath }
    }

    //Cell -> абстратный тип -> UICollectionViewCell
    func registerCell<Cell: UICollectionViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.identifier)
    }

    //Cell -> конкретный тип -> BannerCollectionCell
    func dequeueCell<Cell: UICollectionViewCell>(_ indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as? Cell else { fatalError("Fatal error for cell at \(indexPath)") }
        return cell
    }

    // Метод для регистрации заголовков
    func registerHeader<Header: UICollectionReusableView>(_ headerClass: Header.Type, forKind kind: String = UICollectionView.elementKindSectionHeader) {
        register(headerClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: headerClass.identifier)
    }

    // Метод для переиспользования заголовков
    func dequeueHeader<Header: UICollectionReusableView>(ofKind kind: String = UICollectionView.elementKindSectionHeader, _ indexPath: IndexPath) -> Header {
        guard let header = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Header.identifier, for: indexPath) as? Header else { fatalError("Fatal error for header at \(indexPath)") }
        return header
    }
}

