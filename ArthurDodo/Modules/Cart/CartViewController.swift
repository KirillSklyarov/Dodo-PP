//
//  CartViewController.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 24.09.2024.
//

import UIKit

final class CartViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var orderStackView = OrderStackView()
    private lazy var toppingsStackView = ToppingsStackView()
    private lazy var specialOfferStackView = PromoStackView()
    private lazy var promoButton = PromoButton()
    private lazy var dodoCoinsView = DodoCoinsStackView()
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [orderStackView, toppingsStackView, specialOfferStackView, promoButton, dodoCoinsView])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    private lazy var cartButtonView = CartButtonView()
    private lazy var scrollUpButton = ScrollUpButton()
    private lazy var scrollView = UIScrollView()

    // MARK: - Other Properties
    private let dataStorage = DataStorage.shared
    private lazy var router = Router(baseVC: self)
    private var order: [Order]?
    var onEmptyCart: (() -> Void)?
    var onRefreshCart: (() -> Void)?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        fetchDataFromStorage()
    }
}

// MARK: - Setup UI
private extension CartViewController {
    func setupUI() {
        setupNavigationBar()
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(scrollView, cartButtonView)

        setupScrollView()
        setupLayout()
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = AppColors.backgroundGray
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title = "Корзина"

        let dismissButton = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(dismissButtonTapped))
        dismissButton.tintColor = AppColors.buttonOrange
        dismissButton.setTitleTextAttributes([NSAttributedString.Key .font: AppFonts.semibold18], for: .normal)
        navigationItem.leftBarButtonItem = dismissButton
    }

    @objc func dismissButtonTapped() {
        onRefreshCart?()
        dismiss(animated: true)
    }

    func setupScrollView() {
        scrollView.addSubviews(contentStackView, scrollUpButton)
        let bottomInset = cartButtonView.getHeight()
        scrollView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: bottomInset, right: 0)
        scrollView.delegate = self
    }
}

// MARK: - Setup Actions
private extension CartViewController {
    func setupActions() {
        setupCartProductTableViewAction()
        setupToppingsCollectionView()
        setupSpecialViewActions()
        setupScrollUpButtonAction()
    }

    func setupCartProductTableViewAction() {
        orderStackView.onEmptyCart = { [weak self] in
            guard let self else { return }
            dismiss(animated: true)
            onEmptyCart?()
        }
        orderStackView.onItemDeletedFromCart = { [weak self] in
            self?.fetchDataFromStorage()
        }
        orderStackView.onCountIncreased = { [weak self] in
            self?.fetchDataFromStorage()
        }

        orderStackView.onChangeItem = { [weak self] in
            self?.router.navigate(to: .productDetails)
        }
    }

    func setupScrollUpButtonAction() {
        scrollUpButton.onScrollUpButtonTapped = { [weak self] in
            guard let self else { return }
            let topInset = scrollView.adjustedContentInset.top
            self.scrollView.setContentOffset(CGPoint(x: 0, y: -topInset), animated: true)
        }
    }

    func setupSpecialViewActions() {
        specialOfferStackView.onPromoSelected = { [weak self] specialOffer in
            self?.router.navigate(to: .applySpecialOffer) { [weak self] applyOfferVC in
                guard let applyOfferVC = applyOfferVC as? ApplyOfferViewController else { print("We can't cast applyOfferVC"); return }
                applyOfferVC.configureViewController(specialOffer)
            }
        }
    }

    func setupToppingsCollectionView() {
        toppingsStackView.onNewItemToAddToCart = { [weak self] in
            guard let self else { return }
            fetchDataFromStorage()
            orderStackView.uploadOrder()
        }
    }
}

// MARK: - Fetch Data
private extension CartViewController {
    func fetchDataFromStorage() {
        order = dataStorage.getOrderFromStorage()
        updateUI()
    }

    func updateUI() {
        let countOfItems = order?.compactMap{ $0.count }.reduce(0, +) ?? 0
        let totalPrice = order?.compactMap{ $0.price * $0.count }.reduce(0, +) ?? 0
        let dodoCoins = totalPrice / 10
        orderStackView.setNewData(countOfItems, totalPrice: totalPrice)
        dodoCoinsView.setCountOfItems(countOfItems)
        dodoCoinsView.setTotalPrice(totalPrice)
        dodoCoinsView.setDodoCoins(dodoCoins)
        cartButtonView.updatePrice(totalPrice)
    }
}

// MARK: - Constraints
extension CartViewController {
    private func setupLayout() {
        setupScrollViewConstraints()
        setupContentViewConstraints()
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
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20),
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
        setupScrollUpButton()
    }

    // Метод определяет когда показывать кнопку скролла наверх в зависимости от прокрученного контента
    func setupScrollUpButton() {
        let contentHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y + scrollView.adjustedContentInset.top
        let visibleHeight = scrollView.frame.height

        // Срабатывает когда по каким-то причинам контент еще не загрузился
        if contentHeight == 0 {
            scrollUpButton.isHidden = true
            return
        }

        // Срабатывает когда прокрутили больше половины контента
        if scrollOffset > (contentHeight - visibleHeight) / 2 {
            scrollUpButton.isHidden = false
        } else {
            scrollUpButton.isHidden = true
        }
    }
}
