import UIKit

// Круглая кнопка скролла наверх
final class ScrollUpButton: UIButton {

    // MARK: - Properties
    private let buttonSize: CGFloat = 40
    private lazy var cornerRadius: CGFloat = buttonSize / 2

    var onScrollUpButtonTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension ScrollUpButton {
    func configButton() {
        let image = UIImage(systemName: "chevron.up")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        backgroundColor = AppColors.buttonGray
        setImage(image, for: .normal)
        addTarget(self, action: #selector(scrollUpButtonTapped), for: .touchUpInside)
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        isHidden = true

        setupLayout()
    }

    func setupLayout() {
        widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
    }

    @objc private func scrollUpButtonTapped() {
        onScrollUpButtonTapped?()
    }
}

// MARK: - Setup actions
extension ScrollUpButton {

    // Метод определяет когда показывать кнопку скролла наверх в зависимости от прокрученного контента
    func setupScrollUpButtonAction(scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y + scrollView.adjustedContentInset.top
        let visibleHeight = scrollView.frame.height

        // Срабатывает когда по каким-то причинам контент еще не загрузился
        if contentHeight == 0 {
            isHidden = true
            return
        }

        // Срабатывает когда прокрутили больше половины контента
        if scrollOffset > (contentHeight - visibleHeight) / 2 {
            isHidden = false
        } else {
            isHidden = true
        }
    }
}
