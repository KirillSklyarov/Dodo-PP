import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String.init(describing: self)
    }
}
