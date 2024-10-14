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
    private let buttonWidth: CGFloat = 150

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
    private lazy var deliveryButton = CartButton(isHidden: false, title: "Доставить сюда")
    private lazy var addressTableView = AddressListTableView()
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerStackView, addressTableView, deliveryButton])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupUI()
        setupActions()
    }
}

// MARK: - Fetch data from Network
extension DeliveryAddressSheetView {
    func fetchData() {
        DataStorage.shared.fetchUserAddresses()
        DataStorage.shared.onDataFetchedSuccessfully = { [weak self] in
            self?.addressTableView.reloadData()
        }
    }
}

// MARK: - Setup Actions
private extension DeliveryAddressSheetView {
    func setupActions() {
        setupAddressTableViewActions()
    }

    func setupAddressTableViewActions() {
        addressTableView.onEditAddressButtonTapped = { [weak self] indexPath in
            let address = DataStorage.shared.fetchedUserAddresses[indexPath.row]
            self?.showEditAddressVC(address)
        }
    }

    func showEditAddressVC(_ address: AddressModel) {
        let vc = EditAddressViewController(addressToEdit: address)
        vc.sheetPresentationController?.detents = [.medium()]
        present(vc, animated: true)
    }
}

// MARK: - Setup UI
private extension DeliveryAddressSheetView {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStackView)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPadding),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftPadding),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightPadding),
            contentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomPadding)
        ])
    }
}
