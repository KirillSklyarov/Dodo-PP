//
//  CartViewController.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 24.09.2024.
//

import UIKit

final class CartViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var cartHeader = CartVCHeader()
    private lazy var orderView = OrderView()
    private lazy var cartProductTableView = CartProductTableView()
    private lazy var toppingsHeader = OrderView(title: "Добавить к заказу?")
    private lazy var toppingsCollectionView = AddToCartCollectionView()
    private lazy var specialOfferHeaderView = OrderView(title: "Акции")
    private lazy var specialOfferCollectionView = CartSpOfferCollection()
    private lazy var pageControl = CustomPageControl()
    private lazy var promoButton = PromoButton()
    private lazy var dodoCoinsView = DodoCoinsStackView()
    private lazy var cartButtonView = CartButtonViewFooter()
    private lazy var scrollUpButton = ScrollUpButton()

    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()

    // MARK: - Other Properties
    private let dataStorage = DataStorage.shared
    private var order: [Order]?
    var onEmptyCart: (() -> Void)?
    var onRefreshCart: (() -> Void)?

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()

        loadOrderFromStorage()
    }

    // MARK: - Private methods
    private func setupActions() {
        setupCartHeader()
        setupCartProductTableView()
        setupSpecialOfferCollectionView()
        setupScrollUpButton()
        setupPageControl()
        setupToppingsCollectionView()
    }

    private func loadOrderFromStorage() {
        order = dataStorage.getOrderFromStorage()
        updateUI()
    }

    private func updateUI() {
        let countOfItems = order?.compactMap{ $0.count }.reduce(0, +) ?? 0
        let totalPrice = order?.compactMap{ $0.price * $0.count }.reduce(0, +) ?? 0
        let dodoCoins = totalPrice / 10
        orderView.setNewData(countOfItems, totalPrice: totalPrice)
        dodoCoinsView.setCountOfItems(countOfItems)
        dodoCoinsView.setTotalPrice(totalPrice)
        dodoCoinsView.setDodoCoins(dodoCoins)
        cartButtonView.updatePrice(totalPrice)
    }

    private func setupPageControl() {
        pageControl.onPageChange = { [weak self] page in
            let indexPath = IndexPath(row: page, section: 0)
            self?.specialOfferCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    private func setupScrollUpButton() {
        scrollUpButton.onScrollUpButtonTapped = { [weak self] in
            guard let self else { return }
            let topInset = self.cartHeader.getViewHeight()
            self.scrollView.setContentOffset(CGPoint(x: 0, y: -topInset), animated: true)
        }
    }

    private func setupCartHeader() {
        cartHeader.onCloseButtonTapped = { [weak self] in
            guard let self else { return }
            onRefreshCart?()
            dismiss(animated: true)
        }
    }

    private func setupCartProductTableView() {
        cartProductTableView.onEmptyCart = { [weak self] in
            guard let self else { return }
            dismiss(animated: true)
            onEmptyCart?()
        }
        cartProductTableView.onItemDeletedFromCart = { [weak self] in
            self?.loadOrderFromStorage()
        }
        cartProductTableView.onCountIncreased = { [weak self] in
            self?.loadOrderFromStorage()
        }

        cartProductTableView.onChangeItem = { [weak self] in
            let productVC = ProductDetailsViewController()
            self?.present(productVC, animated: true)
        }
    }

    private func setupSpecialOfferCollectionView() {
        specialOfferCollectionView.onShowNewCell = { [weak self] pageNumber in
            self?.pageControl.currentPage = pageNumber
        }
    }

    private func setupToppingsCollectionView() {
        toppingsCollectionView.onNewItemToAddToCart = { [weak self] in
            guard let self else { return }
            loadOrderFromStorage()
            cartProductTableView.uploadOrder()
        }
    }


    private func setupUI() {
        view.backgroundColor = .black
        view.addSubviews(scrollView, cartHeader, cartButtonView)

        setupScrollView()
        setupContentView()
        setupLayout()
    }

    private func setupScrollView() {
        scrollView.addSubviews(contentView, scrollUpButton)
        let topInset = cartHeader.getViewHeight() + 10
        let bottomInset = cartButtonView.getHeight()
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        scrollView.delegate = self
    }

    private func setupContentView() {
        contentView.addSubviews(orderView, cartProductTableView, specialOfferHeaderView, specialOfferCollectionView, pageControl, promoButton, dodoCoinsView, toppingsHeader, toppingsCollectionView)
    }
}

// MARK: - Constraints
extension CartViewController {
    private func setupLayout() {
        setupCartHeaderConstraints()

        setupScrollViewConstraints()
        setupContentViewConstraints()

        setupOrderViewConstraints()
        setupCartProductTableViewConstraints()
        setupSpecialOfferConstraints()
        setupSpecialOfferCollectionConstraints()
        setupPageControlConstraints()
        setupPromoButtonConstraints()
        setupDodoCoinsViewConstraints()
        setupToppingsHeaderConstraints()
        setupToppingsCollectionConstraints()
        setupScrollUpButtonConstraints()
        setupCartButtonConstraints()
    }

    private func setupScrollViewConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupContentViewConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20),
        ])
    }

    private func setupCartHeaderConstraints() {
        NSLayoutConstraint.activate([
            cartHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cartHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupOrderViewConstraints() {
        NSLayoutConstraint.activate([
            orderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            orderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            orderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func setupCartProductTableViewConstraints() {
        NSLayoutConstraint.activate([
            cartProductTableView.topAnchor.constraint(equalTo: orderView.bottomAnchor, constant: 10),
            cartProductTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cartProductTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func setupToppingsHeaderConstraints() {
        NSLayoutConstraint.activate([
            toppingsHeader.topAnchor.constraint(equalTo: cartProductTableView.bottomAnchor, constant: 5),
            toppingsHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            toppingsHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    private func setupToppingsCollectionConstraints() {
        NSLayoutConstraint.activate([
            toppingsCollectionView.topAnchor.constraint(equalTo: toppingsHeader.bottomAnchor, constant: 5),
            toppingsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            toppingsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    private func setupSpecialOfferConstraints() {
        NSLayoutConstraint.activate([
            specialOfferHeaderView.topAnchor.constraint(equalTo: toppingsCollectionView.bottomAnchor, constant: 20),
            specialOfferHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            specialOfferHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func setupSpecialOfferCollectionConstraints() {
        NSLayoutConstraint.activate([
            specialOfferCollectionView.topAnchor.constraint(equalTo: specialOfferHeaderView.bottomAnchor, constant: 10),
            specialOfferCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            specialOfferCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func setupPageControlConstraints() {
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: specialOfferCollectionView.bottomAnchor, constant: 5),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    private func setupPromoButtonConstraints() {
        NSLayoutConstraint.activate([
            promoButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 5),
            promoButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    private func setupDodoCoinsViewConstraints() {
        NSLayoutConstraint.activate([
            dodoCoinsView.topAnchor.constraint(equalTo: promoButton.bottomAnchor, constant: 20),
            dodoCoinsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dodoCoinsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dodoCoinsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setupScrollUpButtonConstraints() {
        NSLayoutConstraint.activate([
            scrollUpButton.bottomAnchor.constraint(equalTo: cartButtonView.topAnchor, constant: -5),
            scrollUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }

    private func setupCartButtonConstraints() {
        NSLayoutConstraint.activate([
            cartButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cartButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UIScrollViewDelegate
extension CartViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        let visibleHeight = scrollView.frame.height

        if scrollOffset > (contentHeight - visibleHeight) / 2 {
            scrollUpButton.isHidden = false
        } else {
            scrollUpButton.isHidden = true
        }
    }
}
