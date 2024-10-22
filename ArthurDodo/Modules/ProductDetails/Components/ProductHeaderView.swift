//
//  ProductHeader.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 21.09.2024.
//

import UIKit

final class ProductHeaderView: UIView {

    // MARK: - Properties&Callbacks
    var onCloseButtonTapped: (() -> Void)?

    private let buttonSize: CGFloat = 40
    private let viewHeight: CGFloat = 110
    private let titleLabelPadding: CGFloat = 60
    private let buttonLeftPadding: CGFloat = 20
    private let buttonBottomPadding: CGFloat = 10

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.bold20
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var dismissButton = DismissButtonView()
    private lazy var blurView = CustomBlurView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        closeButtonTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func updateTitle(_ title: String) {
        titleLabel.text = title
    }

    func getViewHeight() -> CGFloat {
        viewHeight
    }

    // MARK: - Private methods
    private func closeButtonTapped() {
        dismissButton.onDismissButtonTapped = { [weak self] in
            self?.onCloseButtonTapped?()
        }
    }

    private func configUI() {
        addSubviews(blurView, dismissButton, titleLabel)
        setupLayout()
    }

    private func setupLayout() {
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        setupBlurConstraints()
        setupDismissButtonConstraints()
        setupTitleLabelConstraints()
    }

    private func setupBlurConstraints() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupDismissButtonConstraints() {
        NSLayoutConstraint.activate([
            dismissButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -buttonBottomPadding),
            dismissButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonLeftPadding),
        ])
    }

    private func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: titleLabelPadding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -titleLabelPadding)
        ])
    }
}
