import UIKit

class InsetLabel: UILabel {

    var contentInset: UIEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInset))
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height += contentInset.top + contentInset.bottom
        size.width += contentInset.left + contentInset.right
        return size
    }
}
