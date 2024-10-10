//
//  ProfileViewController.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 10.10.2024.
//

import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = ProfileHeaderView()
    private lazy var coinsOrdersCollectionView = CoinsOrdersCollectionView()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
}

// MARK: - setupActions
private extension ProfileViewController {
    func setupActions() {
        setupHeaderViewActions()
    }

    func setupHeaderViewActions() {
        headerView.onDismissButtonTapped = { [weak self] in
            self?.dismiss(animated: true)
        }

        headerView.onChatButtonTapped = { [weak self] in
            print("ChatButtonTapped")
        }

        headerView.onProfileButtonTapped = { [weak self] in
            print("ProfileButtonTapped")
        }
    }
}

// MARK: - SetupUI
private extension ProfileViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(headerView, coinsOrdersCollectionView)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            coinsOrdersCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            coinsOrdersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            coinsOrdersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
}
