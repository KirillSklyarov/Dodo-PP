//
//  MainViewController.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 05.10.2024.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = HeaderView()
    private lazy var contentCollectionView = ContentCollectionView()
    private lazy var cartButton = CartButton(isHidden: true, isCart: true)

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupActions()
    }
}

// MARK: - Setup Actions
private extension MainViewController {
    func setupActions() {
        setupCollectionView()
        setupHeaderView()
        setupCartButtonActions()
    }

    func setupCollectionView() {
        contentCollectionView.onItemCellTapped = { [weak self] IndexPath in
            let item = allItems[IndexPath.item]
            DataStorage.shared.fetchToppings()
            self?.showProductDetail(item)
        }

        contentCollectionView.onStoriesCellTapped = { [weak self] IndexPath in
            self?.showStoriesVC(IndexPath)
        }

        contentCollectionView.onSpecialOfferCellTapped = { [weak self] IndexPath in
            let item = specialOfferArray[IndexPath.item]
            self?.showProductDetail(item)
        }
    }

    func setupHeaderView() {
        headerView.onProfileButtonTapped = { [weak self] in
            self?.showProfileVC()
        }

        headerView.onAddressTapped = { [weak self] in
            self?.showAddressVC()
        }
    }

    func showProfileVC() {
        let profileVC = ProfileViewController()
        present(profileVC, animated: true)
    }

    func showProductDetail(_ pizza: FoodItems) {
        let productDetailVC = ProductDetailsViewController()
        productDetailVC.getPizzaData(pizza)
        productDetailVC.modalPresentationStyle = .overFullScreen
        productDetailVC.isModalInPresentation = false
        present(productDetailVC, animated: true)

        productDetailVC.onCartButtonTapped = { [weak self] price in
            guard let self else { return }
            cartButton.isHidden = false
            cartButton.setNewPrice(price)
        }
    }

    func showStoriesVC(_ indexPath: IndexPath) {
        let storiesVC = StoriesVC()
        storiesVC.showStories(indexPath)
        storiesVC.modalPresentationStyle = .overFullScreen
        storiesVC.isModalInPresentation = false
        present(storiesVC, animated: true)

        storiesVC.onStoriesVCDismissed = { [weak self] in
            self?.contentCollectionView.reloadData()
        }
    }

    func showAddressVC() {
        let addressVC = AddressViewController()
        addressVC.modalPresentationStyle = .fullScreen
        addressVC.isModalInPresentation = true
        present(addressVC, animated: true)
    }

    func setupCartButtonActions() {
        cartButton.onButtonTapped = { [weak self] in
            self?.showCartVC()
        }
    }

    func showCartVC() {
        let cartVC = CartViewController()
        let navVC = UINavigationController(rootViewController: cartVC)
        present(navVC, animated: true)
    }
}

// MARK: - SetupLayout
private extension MainViewController {
    func configUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(headerView, contentCollectionView, cartButton)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),

            cartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
