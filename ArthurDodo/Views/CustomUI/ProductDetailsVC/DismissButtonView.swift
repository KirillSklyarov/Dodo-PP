//
//  DismissProductView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 02.10.2024.
//

import UIKit

final class DismissButtonView: UIView {

    private let viewSize: CGFloat = 40
    var onDismissButtonTapped: (() -> Void)?

    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()

    init(frame: CGRect = .zero, xColor: UIColor = .white, backgroundColor: UIColor = AppColors.backgroundGray) {
        super.init(frame: frame)
        configUI()
        setColors(xColor: xColor, backgroundColor: backgroundColor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setColors(xColor: UIColor, backgroundColor: UIColor) {
        let image = UIImage(systemName: "xmark")?.withTintColor(xColor, renderingMode: .alwaysOriginal)
        dismissButton.setImage(image, for: .normal)
        self.backgroundColor = backgroundColor
    }


    // MARK: - IB Actions
    @objc private func closeButtonTapped() {
        onDismissButtonTapped?()
    }

    private func configUI() {
        backgroundColor = .darkGray.withAlphaComponent(0.4)

        heightAnchor.constraint(equalToConstant: viewSize).isActive = true
        widthAnchor.constraint(equalToConstant: viewSize).isActive = true

        layer.cornerRadius = viewSize / 2
        layer.masksToBounds = true

        addSubviews(dismissButton)
        
        setupLayout()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: topAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
