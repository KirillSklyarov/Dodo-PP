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
    private lazy var backgroundView = configBackgroundView()
    private lazy var storiesCollectionView = StoriesCollectionView()
    private lazy var specialOfferLabel = configSpecialOfferLabel()
    private lazy var specialOfferCollectionView = SpecialOfferCollectionView()
    private lazy var categoryCollectionView = CategoryCollectionView()
    private lazy var productTableView = ProductTableView()
    private lazy var cartButton = CartButton(isHidden: true)

    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        uploadProductsFromCategory()
        updateCart()
        productCellTapped()
        configCartButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        selectFirstCategory()
    }

    // MARK: - Private methods
    @objc private func cartButtonTapped(_ sender: UIButton) {
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

    // MARK: - Private methods
    private func productCellTapped() {
        productTableView.onCellTapped = { [weak self] pizza in
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

    private func selectFirstCategory() {
        categoryCollectionView.selectFirstCategory(categoryCollectionView)
    }

    private func uploadProductsFromCategory() {
        categoryCollectionView.onUpdateTableView = { [weak self] indexPath in
            self?.updateProductTableView(indexPath)
        }
    }

    private func updateProductTableView(_ indexPath: IndexPath) {
        let products = categories[indexPath.row].items
        productTableView.uploadListOfProducts(products)
    }

    private func updateCart() {
        productTableView.onUpdateCart = { [weak self] price in
            self?.cartButton.setNewPrice(price)
        }
    }

    private func setupUI() {
        view.backgroundColor = .black
        view.addSubviews(headerView, backgroundView, cartButton)

        configScrollView()
        configContentView()

        setupConstraints()
    }

    private func configScrollView() {
        backgroundView.addSubviews(scrollView)
    }

    private func configContentView() {
        scrollView.addSubviews(contentView)

        contentView.addSubviews(storiesCollectionView, specialOfferLabel, specialOfferCollectionView, categoryCollectionView, productTableView)
    }

    private func configCartButton() {
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
    }

    private func configBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = .darkGray.withAlphaComponent(0.4)
        view.layer.cornerRadius = 20
        return view
    }

    private func configSpecialOfferLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = "Выгодно и вкусно"
        label.textColor = .white
        label.textAlignment = .left
        return label
    }
}

// MARK: - SetupConstraints
private extension MainViewController {
    func setupConstraints() {
        setupHeaderViewLayout()
        setupBackgroundViewLayout()
        setupScrollViewLayout()
        setupContentViewLayout()

        setupStoriesLayout()
        setupSpecialOfferHeaderLayout()
        setupSpecialOfferLayout()
        setupCategoryCollectionViewLayout()
        setupProductTableViewLayout()
        setupCarButtonLayout()
    }

    func setupHeaderViewLayout() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
    }

    func setupBackgroundViewLayout() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }

    func setupScrollViewLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        ])
    }

    func setupContentViewLayout() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    func setupStoriesLayout() {
        NSLayoutConstraint.activate([
            storiesCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            storiesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            storiesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }

    func setupSpecialOfferHeaderLayout() {
        NSLayoutConstraint.activate([
            specialOfferLabel.topAnchor.constraint(equalTo: storiesCollectionView.bottomAnchor, constant: 10),
            specialOfferLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            specialOfferLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }

    func setupSpecialOfferLayout() {
        NSLayoutConstraint.activate([
            specialOfferCollectionView.topAnchor.constraint(equalTo: specialOfferLabel.bottomAnchor, constant: 5),
            specialOfferCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            specialOfferCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }

    func setupCategoryCollectionViewLayout() {
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: specialOfferCollectionView.bottomAnchor, constant: 5),
            categoryCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            categoryCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }

    func setupProductTableViewLayout() {
        NSLayoutConstraint.activate([
            productTableView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor),
            productTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            productTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    func setupCarButtonLayout() {
        NSLayoutConstraint.activate([
            cartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
}
