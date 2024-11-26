import UIKit

final class AppLabel: UILabel {

    init(frame: CGRect = .zero, text: String? = nil, textColor: AppColorsEnum, font: AppFontsEnum, alignment: NSTextAlignment = .left, numberOfLines: Int = 0) {
        super.init(frame: frame)
        self.textColor = textColor.color
        self.font = font.font
        self.textAlignment = alignment
        self.numberOfLines = numberOfLines

        setupText(text: text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
/Users/kirillsklyarov/Dodo-PP/ArthurDodo/Modules/Main/Components/AppImageView.swift


private extension AppLabel {
    func setupText(text: String?) {
        if let text { self.text = text }
    }

    // Если картинка квадратная, то тут выставляем размер
//    func setupLayout(squareSize: CGFloat?) {
//        if let squareSize {
//            heightAnchor.constraint(equalToConstant: squareSize).isActive = true
//            widthAnchor.constraint(equalToConstant: squareSize).isActive = true
//        }
//    }
}
