//
//  AddressesView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 21.10.2024.
//

import UIKit

final class DeliveryAddressView: UIView {

    // MARK: - Properties
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let topPadding: CGFloat = 30
    private let bottomPadding: CGFloat = -10
    private let buttonWidth: CGFloat = 150

    private let storage = DataStorage.shared

    var onEditAddressCellTapped: ((Address) -> Void)?

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
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        return button
    }()
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, addAddressButton])
        stackView.axis = .horizontal
        return stackView
    }()
    private lazy var deliveryButton = CartButton(title: "Доставить сюда", isCart: false)
    private lazy var addressTableView = AddressListTableView()
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerStackView, addressTableView, deliveryButton])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI() {
        addressTableView.reloadData()
        addressTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
}

// MARK: - Setup UI
private extension DeliveryAddressView {
    func setupUI() {
        backgroundColor = AppColors.backgroundGray
        layer.cornerRadius = 10
        layer.masksToBounds = true
        addSubviews(contentStackView)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: topPadding),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftPadding),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightPadding),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomPadding)
        ])
    }
}

// MARK: - Setup Actions
private extension DeliveryAddressView {
    func setupActions() {
        setupAddressTableViewActions()
        setupDeliveryButtonAction()
    }

    func setupAddressTableViewActions() {
        addressTableView.onEditAddressButtonTapped = { [weak self] indexPath in
            guard let self else { return }
            let address = storage.fetchedUserAddresses[indexPath.row]
            onEditAddressCellTapped?(address)
        }
    }

//    func showEditAddressVC(_ address: Address) {
//        let vc = EditAddressViewController(addressToEdit: address)
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true)
//    }

    func setupDeliveryButtonAction() {
        deliveryButton.onButtonTapped = {
            print("We're here")
        }
    }
}
