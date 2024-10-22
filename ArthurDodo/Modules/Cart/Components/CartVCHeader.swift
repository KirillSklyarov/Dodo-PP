//
//  CartVCHeader.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 24.09.2024.
//

import UIKit

final class CartVCHeader: UIView {

    // MARK: - Properties&Callbacks
    var onCloseButtonTapped: (() -> Void)?
    private let viewHeight: CGFloat = 60

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Корзина"
        label.textColor = .white
        label.font = AppFonts.semibold18
        return label
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("Закрыть", for: .normal)
        button.setTitleColor(AppColors.buttonOrange, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var blurView = CustomBlurView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - IB Actions
    @objc private func closeButtonTapped() {
        onCloseButtonTapped?()
    }

    // MARK: - Public methods
    func getViewHeight() -> CGFloat {
        viewHeight
    }
}

// MARK: - Setup UI
private extension CartVCHeader {
    func configUI() {
        addSubviews(blurView, dismissButton, titleLabel)
        setupLayout()
    }

    func setupLayout() {
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        setupBlurLayout()
        setupDismissButtonConstraints()
        setupTitleLabelConstraints()
    }

    func setupBlurLayout() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupDismissButtonConstraints() {
        NSLayoutConstraint.activate([
            dismissButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
    }

    func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
