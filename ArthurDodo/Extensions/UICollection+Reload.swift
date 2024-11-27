import UIKit

extension UICollectionView {
    func reloadCollection() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }
}
