//
//  CustomStepperView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 24.09.2024.
//

import UIKit

final class CustomStepperView: UIView {

    // MARK: - Properties
    private let viewHeight: CGFloat = 25
    private let viewWidth: CGFloat = 90
    private let cornerRadius: CGFloat = 10

    private var value: Int = 0 {
        didSet {
            if value < 0 { value = 0 }
            valueLabel.text = "\(value)"
        }
    }

    var onValueIsNull: (() -> Void)?
    var onStepperValueChanged: ( (Int) -> Void)?

    // MARK: - UI properties
    private lazy var decrementButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "minus")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(decrementButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var incrementButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.text = "\(value)"
        label.textColor = .white
        label.font = AppFonts.semibold14
        label.textAlignment = .center
        return label
    }()
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [decrementButton, valueLabel, incrementButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: - Init
    init(frame: CGRect = .zero, isHidden: Bool = false) {
        super.init(frame: frame)
        setupUI()
        self.isHidden = isHidden
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func setStepperValue(_ value: Int) {
        self.value = value
    }
}

// MARK: - Setup Actions
private extension CustomStepperView {
    @objc private func decrementButtonTapped() {
        value -= 1
        if value == 0 {
            onValueIsNull?()
        } else {
            onStepperValueChanged?(value)
        }
    }

    @objc private func incrementButtonTapped() {
        value += 1
        onStepperValueChanged?(value)
    }
}

// MARK: - Setup UI
private extension CustomStepperView {
    func setupUI() {
        backgroundColor = AppColors.buttonGray
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        addSubviews(contentStack)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),

            heightAnchor.constraint(equalToConstant: viewHeight),
            widthAnchor.constraint(equalToConstant: viewWidth)
        ])
    }
}
