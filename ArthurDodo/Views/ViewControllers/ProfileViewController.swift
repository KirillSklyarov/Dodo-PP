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
    private lazy var specialOfferStackView = SpecialOfferStackView()
    private lazy var missionStackView = MissionStackView()

    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [coinsOrdersCollectionView, specialOfferStackView, missionStackView])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    private lazy var scrollView = UIScrollView()

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
        setupSpecialOfferActions()
    }

    func setupHeaderViewActions() {
        headerView.onDismissButtonTapped = { [weak self] in
            self?.dismiss(animated: true)
        }

        headerView.onChatButtonTapped = { [weak self] in
            self?.showChatAlert()
        }

        headerView.onProfileButtonTapped = { [weak self] in
            print("ProfileButtonTapped")
        }
    }

    func showChatAlert() {
        AlertHelper.showChatAlert(in: self)
    }

    func setupSpecialOfferActions() {
        specialOfferStackView.onSpecialOfferSelected = { [weak self] specialOffer in
            let vc = ApplyOfferViewController()
            guard let configureSheet = vc.sheetPresentationController else { return }
            configureSheet.detents = [.medium()]
            configureSheet.prefersGrabberVisible = true
            vc.configureViewController(specialOffer)
            self?.present(vc, animated: true)
        }
    }
}

// MARK: - SetupUI
private extension ProfileViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(headerView, scrollView)

        setupLayout()

        setupScrollView()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func setupScrollView() {
        scrollView.addSubviews(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
}
