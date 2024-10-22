//
//  EditAddressView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 20.10.2024.
//

import UIKit

final class EditAddressView: UIView {

    // MARK: - Properties
    private let topInset: CGFloat = 10
    private let bottomInset: CGFloat = -10
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10

    private lazy var addressStackView = EditAddressStackView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func updateUIWithAddress(_ addressToEdit: Address) {
        addressStackView.updateUIWithData(addressToEdit)
    }

    func setupSaveButtonAction(_ addressToEdit: Address) {
        addressStackView.setupButtonAction(addressToEdit)
    }

    func updateBasicAddress(_ basicAddress: String) {
        addressStackView.updateUIBasicAddress(basicAddress)
    }
}

// MARK: - Setup UI
private extension EditAddressView {
    func setupUI() {
        backgroundColor = AppColors.backgroundGray
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubviews(addressStackView)

        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            addressStackView.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
            addressStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInset),
            addressStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightInset),
            addressStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
