import UIKit

// Так как ячейка наследуется от UICollectionReusableView, то нужно только тут определить identifier и он будет и в заголовках и в ячейках
extension UICollectionReusableView {
    static var identifier: String {
      String(describing: self)
    }
}
