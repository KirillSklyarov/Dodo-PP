import UIKit

final class AppLabel: UILabel {

    init(frame: CGRect = .zero, text: String? = nil, textColor: AppColorsEnum, font: AppFontsEnum, alignment: NSTextAlignment = .left, numberOfLines: Int = 0, height: CGFloat? = nil, adjustsFontSizeToFitWidth: Bool = false) {
        super.init(frame: frame)
        self.textColor = textColor.color
        self.font = font.font
        self.textAlignment = alignment
        self.numberOfLines = numberOfLines
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth

        setupText(text: text)
        setupHeight(height)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AppLabel {
    // Устанавливает текст
    func setupText(text: String?) {
        if let text { self.text = text }
    }

    func setupHeight(_ height: CGFloat?) {
        if let height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
