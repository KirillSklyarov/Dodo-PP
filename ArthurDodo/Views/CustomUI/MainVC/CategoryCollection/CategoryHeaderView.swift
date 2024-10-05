//
//  CategoryHeaderView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 02.10.2024.
//

import UIKit

final class CategoryHeaderView: UIView {

    private let viewHeight: CGFloat = 50

    var buttons: [UIButton] = []
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        highlightCategory(at: sender.tag)
    }

    private func setupUI() {
        for (index, category) in categories.enumerated() {
            let button = UIButton()
            button.setTitle(category.header, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            buttons.append(button)
            stack.addArrangedSubview(button)
        }
    }

    private func setupLayout() {
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true

        addSubviews(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func highlightCategory(at index: Int) {
        for (i, button) in buttons.enumerated() {
            button.isSelected = (i == index)
            button.setTitleColor(i == index ? .blue : .white, for: .normal)
        }
    }
}
