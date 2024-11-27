import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String.init(describing: self)
    }

    // Настраивает accessoryView у ячейки в виде правого шеврона
    func setupAccessoryView() {
        let image = UIImage(systemName: "chevron.right")?.withTintColor(AppColors.grayFont, renderingMode: .alwaysOriginal)
        let chevronView = UIImageView(image: image)
        accessoryView = chevronView
    }
}
