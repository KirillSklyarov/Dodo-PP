//
//  ViewController.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 17.09.2024.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = HeaderView()
    private lazy var backgroundView = BackgroundView()
    private lazy var storiesCollectionView = StoriesCollectionView()
    private lazy var specialOfferLabel = SpecialOfferLabel()
    private lazy var specialOfferCollectionView = SpecialOfferCollectionView()
    private lazy var categoryHeaderCollectionView = CategoryHeaderCollectionView()
    private lazy var productsCollectionView = ProductCollectionView()

    private lazy var cartButton = CartButton(isHidden: true)

    private lazy var scrollView = AppScrollView()
    private lazy var contentView = CustomContentView()
    private lazy var placeholderView = PlaceholderView()

    private lazy var stackView = ContentStackView(arrangedSubviews: [storiesCollectionView, specialOfferLabel, specialOfferCollectionView, placeholderView, productsCollectionView])

    // MARK: - Other Properties
    var collectionHeaderTopConstraint: NSLayoutConstraint?
    var isCollectionFixed = false

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        dataBinding()
    }

    // MARK: - Private methods
    private func dataBinding() {
        setupProductsCollectionView()
        scrollToProductsFromSelectedCategory()
        productCellTapped()
        configCartButton()
//        setupCartButtonCallbacks()

        setupHeaderView()
    }

    private func setupHeaderView() {
        headerView.onProfileButtonTapped = { [weak self] in
            let profileVC = ProfileVC()
            profileVC.modalPresentationStyle = .fullScreen
            self?.present(profileVC, animated: true)
        }
    }

    private func configCartButton() {
        cartButton.onCartButtonTapped = { [weak self] in
            guard let self else { return }
            let cartVC = CartViewController()
            present(cartVC, animated: true)

            cartVC.onEmptyCart = { [weak self] in
                guard let self else { return }
                cartButton.resetPrice()
                cartButton.isHidden = true
            }

            cartVC.onRefreshCart = { [weak self] in
                self?.cartButton.getTotalCartPriceFromStorage()
            }
        }
    }

    private func productCellTapped() {
        productsCollectionView.onCellSelected = { [weak self] pizza in
            let productDetailVC = ProductDetailsViewController()
            productDetailVC.getPizzaData(pizza)
            productDetailVC.modalPresentationStyle = .overFullScreen
            productDetailVC.isModalInPresentation = false
            self?.present(productDetailVC, animated: true)

            productDetailVC.onCartButtonTapped = { [weak self] orderPrice in
                guard let self else { return }
                self.cartButton.setNewPrice(orderPrice)
                self.cartButton.isHidden = false
            }
        }
    }

    private func scrollToProductsFromSelectedCategory() {
        categoryHeaderCollectionView.onUpdateProductsCollectionView = { [weak self] section in
            guard let self = self else { return }
            let indexPath = IndexPath(item: 0, section: section)
            productsCollectionView.setIsScrolling(true)
            productsCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.productsCollectionView.setIsScrolling(false)
            }
        }
    }

    private func setupUI() {
        view.backgroundColor = .black
        view.addSubviews(headerView, backgroundView, categoryHeaderCollectionView, cartButton)

        configScrollView()
        setupConstraints()
    }

    private func configScrollView() {
        backgroundView.addSubviews(scrollView)
        scrollView.delegate = self
        configContentView()
    }

    private func configContentView() {
        scrollView.addSubviews(contentView)
        configStackView()
    }

    private func configStackView() {
        contentView.addSubviews(stackView)
    }

    private func setupProductsCollectionView() {
        productsCollectionView.onChangeCategoryName = { [weak self] newIndexPath in
            guard let self else { return }
            let categoryIndex = IndexPath(item: newIndexPath.section, section: 0)
            categoryHeaderCollectionView.selectCell(categoryIndex)
        }
    }
}

// MARK: - SetupConstraints
private extension MainViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 5),
            productsCollectionView.heightAnchor.constraint(equalToConstant: 800),
            cartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])

        setupInitialHeaderLayout()
    }
}

// MARK: - UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isNeedToFixHeader() { fixCategoryHeaderOnTop() }
        if isNeedToUnfixHeader() { setupInitialHeaderLayout() }
    }

    // Проверяем что верх хэдера ушел за пределы backgroundView
    private func isNeedToFixHeader() -> Bool {
        let categoryHeaderFrame = categoryHeaderCollectionView.convert(categoryHeaderCollectionView.bounds, to: view)
        let backgroundFrame = backgroundView.convert(backgroundView.bounds, to: view)

        return categoryHeaderFrame.origin.y <= backgroundFrame.origin.y && !isCollectionFixed
    }

    // Проверяем что прокрутка Скролла уже меньше чем вершина placeholderView
    private func isNeedToUnfixHeader() -> Bool {
        return scrollView.contentOffset.y < placeholderView.frame.origin.y && isCollectionFixed
    }

    // Тут мы размещаем header в его месте
    private func setupInitialHeaderLayout() {
        collectionHeaderTopConstraint?.isActive = false
        collectionHeaderTopConstraint = categoryHeaderCollectionView.topAnchor.constraint(equalTo: placeholderView.topAnchor)
        collectionHeaderTopConstraint?.isActive = true
        isCollectionFixed = false
    }

    // Тут мы фиксируем header наверху
    private func fixCategoryHeaderOnTop() {
        collectionHeaderTopConstraint?.isActive = false
        collectionHeaderTopConstraint = categoryHeaderCollectionView.topAnchor.constraint(equalTo: backgroundView.topAnchor)
        collectionHeaderTopConstraint?.isActive = true
        isCollectionFixed = true
    }
}


//    private func setupCartButtonCallbacks() {
//        productsCollectionView.onUpdateCart = { [weak self] price in
//            self?.cartButton.setNewPrice(price)
//        }
//    }

//    private func updateCollectionViewHeight() {
//        let collectionHeight = productsCollectionView.collectionViewLayout.collectionViewContentSize.height
//        collectionHeightConstraint?.constant = collectionHeight
//        print(collectionHeight)
//        collectionHeightConstraint?.isActive = true
//    }
