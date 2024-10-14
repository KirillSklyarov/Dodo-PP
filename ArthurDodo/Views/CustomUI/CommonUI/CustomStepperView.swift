//
//  CustomStepperView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 24.09.2024.
//

import UIKit

final class CustomStepperView: UIView {

    private let viewHeight: CGFloat = 25

    private var value: Int = 0 {
        didSet {
            if value < 0 { value = 0 }
            valueLabel.text = "\(value)"
        }
    }

    var onValueIsNull: (() -> Void)?
    var onStepperValueChanged: ( (Int) -> Void)?

    private let dataStorage = DataStorage.shared

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
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [decrementButton, valueLabel, incrementButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    init(frame: CGRect = .zero, isHidden: Bool) {
        super.init(frame: frame)
        setupUI()
        self.isHidden = isHidden
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - IB Action
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

    // MARK: - Public methods
    func setStepperValue(_ value: Int) {
        self.value = value
    }

    // MARK: - Private methods
    private func setupUI() {
        backgroundColor = .darkGray.withAlphaComponent(0.4)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true

        addSubviews(stackView)
        setupLayout()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
