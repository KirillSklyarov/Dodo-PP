//
//  DeliveryAddressSheetView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 12.10.2024.
//

import UIKit

final class DeliveryAddressSheetView: UIViewController {

    // MARK: - Properties
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let topPadding: CGFloat = 30
    private let bottomPadding: CGFloat = -10
    private let buttonWight: CGFloat = 150

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Мои адреса"
        label.font = AppFonts.bold26
        label.textColor = .white
        return label
    }()
    private lazy var addAddressButton: UIButton = {
        let button = UIButton()
        let title = "+ Новый адрес"
        var config = UIButton.Configuration.filled()
        config.title = title
        config.attributedTitle = AttributedString(title, attributes:
        AttributeContainer([ .font: AppFonts.bold14]))
        config.baseForegroundColor = .white
        config.baseBackgroundColor = AppColors.buttonGray
        config.cornerStyle = .capsule
        button.configuration = config
        button.widthAnchor.constraint(equalToConstant: buttonWight).isActive = true
        return button
    }()
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, addAddressButton])
        stackView.axis = .horizontal
        return stackView
    }()
    private lazy var deliveryButton = CartButton(isHidden: false, title: "Доставить сюда")

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Setup UI
private extension DeliveryAddressSheetView {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(headerStackView, deliveryButton)

        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPadding),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftPadding),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightPadding),

            deliveryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftPadding),
            deliveryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightPadding),
            deliveryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomPadding)
        ])
    }
}
