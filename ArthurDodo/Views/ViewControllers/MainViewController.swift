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
    private lazy var loadingIndicator = UIActivityIndicatorView(style: .large)

    private let storage = DataStorage.shared

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupActions()
        fetchAllData()
    }
}

// MARK: - Fetch data from server
private extension MainViewController {
    func fetchAllData() {
        showLoadingIndicator()
        getStoriesFromServer()
        getCatalogAndSpecialOffersFromServer()
    }

    // Мы обращаемся к хранилищу за сторисами, инициируем сетевой запрос и забираем результаты
    func getStoriesFromServer() {
        storage.fetchStories()
    }

    // Мы обращаемся к хранилищу за каталогом, инициируем сетевой запрос и забираем результаты. Так как спецпредложения это рандомная выборка из каталога, то можно делать это тут же.
    func getCatalogAndSpecialOffersFromServer() {
        storage.fetchItems()

        storage.onItemsFetchedSuccessfully = { [weak self] items in
            guard let self else { return }
            DispatchQueue.main.async {
                self.updateSpecialOffersUI()
                self.hideLoadingIndicator()
            }
        }
    }

    // Вызываем обновление UI всех секций
    func updateSpecialOffersUI() {
        contentCollectionView.uploadDataFromStorage()
    }
}

// MARK: - Setup Loading Indicator
private extension MainViewController {

    func setupLoadingIndicator() {
        loadingIndicator.color = UIColor.white
    }

    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
        contentCollectionView.isHidden = true
    }

    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
        contentCollectionView.isHidden = false
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
            guard let self else { return }
            let catalog = storage.getCatalog()
            let item = catalog[IndexPath.item]
            storage.fetchToppings()
            showProductDetail(item)
        }

        contentCollectionView.onStoriesCellTapped = { [weak self] IndexPath in
            self?.showStoriesVC(IndexPath)
        }

        contentCollectionView.onSpecialOfferCellTapped = { [weak self] IndexPath in
            guard let self else { return }
            let specialOfferArray = storage.getSpecialOffersArray()
            let item = specialOfferArray[IndexPath.item]
            showProductDetail(item)
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

    func showProductDetail(_ pizza: Item) {
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
        view.addSubviews(headerView, contentCollectionView, cartButton, loadingIndicator)
        setupLayout()
        setupLoadingIndicator()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),

            cartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
