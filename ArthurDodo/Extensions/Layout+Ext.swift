import UIKit

extension NSLayoutConstraint {
    // Позволяет выставлять приоритеты прямо в констреинтах
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
