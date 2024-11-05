import UIKit

final class DismissButtonView: UIView {

    // MARK: - Properties&Callbacks
    private let viewSize: CGFloat = 40
    var onDismissButtonTapped: (() -> Void)?

    // MARK: - UI Properties
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Init
    init(frame: CGRect = .zero, xColor: UIColor = .white, backgroundColor: UIColor = AppColors.backgroundGray, isChevron: Bool = false) {
        super.init(frame: frame)
        setupUI()
        setColors(xColor: xColor, backgroundColor: backgroundColor)
        if isChevron { setChevron() }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup actions
private extension DismissButtonView {
    @objc func closeButtonTapped() {
        onDismissButtonTapped?()
    }
}

// MARK: - Setup UI
private extension DismissButtonView {
    func setupUI() {
        backgroundColor = .darkGray.withAlphaComponent(0.4)

        heightAnchor.constraint(equalToConstant: viewSize).isActive = true
        widthAnchor.constraint(equalToConstant: viewSize).isActive = true

        layer.cornerRadius = viewSize / 2
        layer.masksToBounds = true

        addSubviews(dismissButton)
        
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: topAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Supporting methods
private extension DismissButtonView {
    func setColors(xColor: UIColor, backgroundColor: UIColor) {
        let image = UIImage(systemName: "xmark")?.withTintColor(xColor, renderingMode: .alwaysOriginal)
        dismissButton.setImage(image, for: .normal)
        self.backgroundColor = backgroundColor
    }

    func setChevron() {
        let image = UIImage(systemName: "chevron.left")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        dismissButton.setImage(image, for: .normal)
    }
}

