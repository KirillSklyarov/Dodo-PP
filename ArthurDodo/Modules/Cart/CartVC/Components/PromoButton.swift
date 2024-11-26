import UIKit

final class PromoButton: UIButton {

    // MARK: - Properties
    private let buttonHeight: CGFloat = 50

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPromoButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func setupPromoButton() {
        setTitle("Ввести промокод", for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = AppFonts.bold20
        backgroundColor = AppColors.backgroundGray
        layer.cornerRadius = 10
        layer.cornerRadius = 20
        layer.masksToBounds = true
        heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }
}
