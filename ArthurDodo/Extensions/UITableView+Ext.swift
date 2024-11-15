import UIKit

extension UITableView {
    func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }

    func dequeueCell<Cell: UITableViewCell>(_ indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? Cell
        else { fatalError("Fatal error for cell at \(indexPath)") }

        return cell
    }
}
