import UIKit

enum AccessoryViewType {
    case chevron
    case checkmark
}

extension UITableViewCell {
    static var identifier: String {
        return String.init(describing: self)
    }

    // Настраивает accessoryView у ячейки либо в виде правого шеврона, либо в виде оранжевой галки
    func setAccessoryView(_ type: AccessoryViewType) {
        var accessoryImage: UIImage?

        switch type {
        case .chevron:
            accessoryImage = UIImage(systemName: "chevron.right")?.withTintColor(AppColors.grayFont, renderingMode: .alwaysOriginal)
        case .checkmark:
            accessoryImage = UIImage(systemName: "checkmark")?.withTintColor(AppColors.buttonOrange, renderingMode: .alwaysOriginal)
        }

        let appAccessoryView = UIImageView(image: accessoryImage)
        accessoryView = appAccessoryView
    }
}
