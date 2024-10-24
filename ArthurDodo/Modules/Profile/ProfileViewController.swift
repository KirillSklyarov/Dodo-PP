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
    private lazy var promoStackView = PromoStackView()
    private lazy var missionStackView = MissionStackView()
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [coinsOrdersCollectionView, promoStackView, missionStackView])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    private lazy var scrollView = UIScrollView()

    // MARK: - Other Properties
    private let storage = DataStorage.shared
    private lazy var router = Router(baseVC: self)

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        fetchData()
    }
}

// MARK: - Fetch Data
private extension ProfileViewController {
    func fetchData() {
        storage.fetchPromo()

        storage.onPromoFetchedSuccessfully = { [weak self] promo in
            DispatchQueue.main.async {
                self?.promoStackView.updateUI(promo)
            }
        }
    }
}

// MARK: - Setup Actions
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
            self?.showPersonalVC()
        }
    }

    func showChatAlert() {
        router.navigate(to: .supportAlert, animated: false)
    }

    func showPersonalVC() {
        router.navigate(to: .personalData)
    }

    func setupSpecialOfferActions() {
        promoStackView.onPromoSelected = { [weak self] specialOffer in
            self?.router.navigate(to: .applySpecialOffer) { [weak self] applyOfferVC in
                guard let applyOfferVC = applyOfferVC as? ApplyOfferViewController else { print("We can't cast to ApplyOfferViewController"); return }
                applyOfferVC.configureViewController(specialOffer)
            }
        }
    }

}

// MARK: - Setup UI
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
