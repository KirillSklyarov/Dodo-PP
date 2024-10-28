import UIKit


// Этот класс таблицы позволяет не выставлять высоту, она высчитывается автоматом
class AppTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: contentSize.width, height: contentSize.height)
    }

    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
    }
}
