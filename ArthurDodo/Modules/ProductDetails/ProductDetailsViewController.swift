//
//  ProductDetailsViewController.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 19.09.2024.
//

import UIKit

final class ProductDetailsViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = ProductHeaderView()
    private lazy var itemDetailsView = DetailsView()
    private lazy var infoAndToppingsContainer = InfoAndToppingsView()
    private lazy var cartButtonView = CartButtonView()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [itemDetailsView, infoAndToppingsContainer])
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    private lazy var scrollView = UIScrollView()

    // MARK: - Other Properties
    private let storage = DataStorage.shared
    private lazy var router = Router(baseVC: self)

    private var item: Item?
    private var order: Order?

    var onCartButtonTapped: ( (Int) -> Void )?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        fetchSelectedItem()
        setupSwipe()
    }
}

// MARK: - Setup UI
private extension ProductDetailsViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        configScrollView()
        setupConstraints()
    }

    func configScrollView() {
        view.addSubviews(scrollView, headerView, cartButtonView)

        scrollView.backgroundColor = AppColors.backgroundGray
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)

        scrollView.addSubviews(contentStack)
    }

    func setupConstraints() {
        setupScrollViewConstraints()
        setupContentViewConstraints()
        setupProductHeaderViewConstraints()
        setupCartButtonConstraints()
    }

    func setupScrollViewConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cartButtonView.topAnchor)
        ])
    }

    func setupContentViewConstraints() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    func setupProductHeaderViewConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func setupCartButtonConstraints() {
        NSLayoutConstraint.activate([
            cartButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cartButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Setup Actions
private extension ProductDetailsViewController {
    func setupActions() {
        setupHeaderAction()
        sendCartToInfoView()
        setupCartViewAction()
        setupSizeSegmentAction()
        setupInfoButtonAction()
    }

    func setupHeaderAction() {
        headerView.onCloseButtonTapped = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    func sendCartToInfoView() {
        infoAndToppingsContainer.getCartView(cartButtonView)
    }
    
    func setupCartViewAction() {
        cartButtonView.onCartButtonTapped = { [weak self] finalPrice in
            guard let self else { return }
            configureOrder()
            guard let order else { return }
            storage.sendToOrderStorage(order)
            self.onCartButtonTapped?(finalPrice)
            self.dismiss(animated: true)
        }
    }

    func configureOrder() {
        guard let item else { return }
        let chosenSize = getCorrectSize()
        let chosenDough = getCorrectDough()
        let weight = getCorrectWeight()
        let price = item.getCorrectPrice(size: chosenSize)

        order = Order(pizzaName: item.name, imageName: item.imageName, size: chosenSize, dough: chosenDough, weight: weight, price: price, isHit: item.isHit)
    }

    func getCorrectWeight() -> Int {
        guard let item else { return 0 }
        var weight: Int?
        if item.hasOneSize() {
            weight = item.itemSize.oneSize?.weight
        } else {
            weight = item.itemSize.medium?.weight
        }
        return weight ?? 0
    }

    // Если есть размер oneSize, то берем его, если нет - выбранный размер
    func getCorrectSize() -> Size {
        guard let item else { return .oneSize }
        let correctSize: Size = if item.hasOneSize() {
            .oneSize
        } else { itemDetailsView.getChosenSize() }
        return correctSize
    }

    // Если товар - пицца, то берем тесто, если нет - ничего
    func getCorrectDough() -> Dough? {
        guard let item else { return nil }
        let chosenDough: Dough? = if item.category == .pizza {
            itemDetailsView.getChosenDough()
        } else { nil }
        return chosenDough
    }

    func setupSizeSegmentAction() {
        itemDetailsView.onSegmentValueChanged = { [weak self] index in
            guard let self else { return }
            updateUIWithChosenSize(index)
        }
    }

    func updateUIWithChosenSize(_ index: Int) {
        guard let productDetails = item?.itemSize.getWeightAndPriceViaIndex(index) else {print("We have some problems here"); return }
        infoAndToppingsContainer.updateUI(productDetails: productDetails)
        let price = productDetails.price
        cartButtonView.updatePrice(price)
    }

    func setupInfoButtonAction() {
        infoAndToppingsContainer.onShowPopupVC = { [weak self] popupVC in
            guard let self else { print("Self is nil"); return }
            guard let popupVC = popupVC as? CpfcPopupView else {
                print("No popupVC"); return }
            router.navigate(to: .cpfcPopup, popUpView: popupVC)
        }
    }
}

// MARK: - Fetch Data
private extension ProductDetailsViewController {
    func fetchSelectedItem() {
        guard let item = storage.getSelectedItemFromStorage() else { print("No item selected"); return }
        self.item = item
        infoAndToppingsContainer.getItem(item)
        updateUIWithSelectedItem()
    }
}

// MARK: - Update UI for The Item (настраиваем экран для конкретного товара)
private extension ProductDetailsViewController {
    func updateUIWithSelectedItem() {
        updateUIWithItem()
        isItemPizza()
        isOneSize()
    }

    // Если это не пицца, то не нужно показывать поле с тестом
    func isItemPizza() {
        if item?.category != .pizza {
            itemDetailsView.hideDoughSegment()
        }
    }

    // Если размер один, то не нужно показывать поле с размерами, обновляем вес и цену товара
    func isOneSize() {
        if let oneSize = item?.itemSize.oneSize {
            itemDetailsView.hideSizeSegment()
            infoAndToppingsContainer.updateWeight(oneSize.weight)
            cartButtonView.updatePrice(oneSize.price)
        }
    }

    func updateUIWithItem() {
        guard let item else { return }
        headerView.updateTitle(item.name)
        itemDetailsView.updatePizzaImage(item.imageName)
        infoAndToppingsContainer.updateIngredientsAndWeight(item)
        cartButtonView.updatePrice(item.itemSize.medium?.price ?? 0)
    }
}

// MARK: - Setup dismiss by swipe
private extension ProductDetailsViewController {
    func setupSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(vcSwiped))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
    }

    @objc private func vcSwiped() {
        dismiss(animated: true)
    }
}
