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
    private lazy var ingredientsView = IngredientsView()
    private lazy var toppingsCollectionView = AddToppingsCollectionView()
    private lazy var infoAndToppingsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ingredientsView, toppingsCollectionView])
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    private lazy var infoAndToppingsContainer: UIView = {
        let view = UIView()
        view.addSubviews(infoAndToppingsStack)
        view.backgroundColor = AppColors.backgroundGray
        return view
    }()
    private lazy var cartButtonView = CartButtonView()
    private lazy var infoPopupView = InfoPopupView(item: item)

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [itemDetailsView, infoAndToppingsContainer])
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    private lazy var scrollView = UIScrollView()

    // MARK: - Other Properties
    private let storage = DataStorage.shared
    private var tapGesture: UITapGestureRecognizer?
    private var item: Item?
    private var order: Order?

    var onCartButtonTapped: ( (Int) -> Void )?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        fetchSelectedItem()
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
        let bottomHeight = cartButtonView.getHeight() + 10
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomHeight, right: 0)

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
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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

    func setupInfoPopupViewConstraints() {
        let buttonFrame = ingredientsView.getButtonFrame()

        NSLayoutConstraint.activate([
            infoPopupView.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonFrame.origin.x - 10),
            infoPopupView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: buttonFrame.origin.y)
        ])
    }

    func setupCartButtonConstraints() {
        NSLayoutConstraint.activate([
            cartButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cartButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func setupInfoAndToppingsStackConstraints() {
        NSLayoutConstraint.activate([
            infoAndToppingsStack.topAnchor.constraint(equalTo: infoAndToppingsContainer.topAnchor),
            infoAndToppingsStack.leadingAnchor.constraint(equalTo: infoAndToppingsContainer.leadingAnchor, constant: 10),
            infoAndToppingsStack.trailingAnchor.constraint(equalTo: infoAndToppingsContainer.trailingAnchor, constant: -10),
            infoAndToppingsStack.bottomAnchor.constraint(equalTo: infoAndToppingsContainer.bottomAnchor)
        ])
    }
}

// MARK: - Setup Actions
private extension ProductDetailsViewController {
    func setupActions() {
        setupHeaderAction()
        setupToppingsCollectionViewActions()
        setupCartViewAction()
        setupSizeSegmentAction()
        setupInfoButtonAction()
        setupInfoAndToppingsStackConstraints()
    }

    func setupHeaderAction() {
        headerView.onCloseButtonTapped = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    func setupToppingsCollectionViewActions() {
        toppingsCollectionView.onToppingSelected = { [weak self] toppingPrice in
            guard let self else { return }
            var currentPrice = self.cartButtonView.getCurrentPrice()
            currentPrice += toppingPrice
            print(currentPrice)
            self.cartButtonView.updatePrice(currentPrice)
        }

        toppingsCollectionView.onDataFetchedSuccessfully = { [weak self] in
            DispatchQueue.main.async {
                self?.toppingsCollectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }

    func setupCartViewAction() {
        cartButtonView.isHidden = false
        cartButtonView.onCartButtonTapped = { [weak self] finalPrice in
            guard let self,
                  let item else { return }
            let chosenSize = itemDetailsView.getChosenSize()
            let chosenDough = itemDetailsView.getChosenDough()

            let price = item.itemSize.medium?.price ?? 0

//            if let pizza = item as? Pizza {
//                price = pizza.itemSize[chosenSize]?.price ?? 0
//            }

            order = Order(pizzaName: item.name, imageName: item.imageName, size: chosenSize, dough: chosenDough, price: price, isHit: item.isHit)
            guard let order else { return }
            storage.sendToOrderStorage(order)
            self.onCartButtonTapped?(finalPrice)
            self.dismiss(animated: true)
        }
    }

    func setupSizeSegmentAction() {
        itemDetailsView.onSegmentValueChanged = { [weak self] index in
            guard let self else { return }

//            var size: String = "small"
//            switch index {
//            case 0: size = "small"
//            case 1: size = "medium"
//            case 2: size = "large"
//            default: break }

            guard let productDetails = item?.itemSize.getWeightAndPriceViaIndex(index) else {print("1231231231313"); return }

            let weight = productDetails.weight
//            self.item?.itemSize.size .size?.weight ?? 0
            let price = productDetails.price
//            self.item?.itemSize[size]?.price ?? 0
            self.ingredientsView.updateWeight(weight)
            self.cartButtonView.updatePrice(price)
            self.infoPopupView.setProductDetails(productDetails)
        }
    }

    func setupInfoButtonAction() {
        ingredientsView.onInfoButtonTapped = { [weak self] in
            guard let self else { return }
            if self.infoPopupView.isHidden {
                self.showPopupView()
            } else {
                self.hidePopupView()
            }
        }
    }
}

// MARK: - Fetch Data
private extension ProductDetailsViewController {
    func fetchSelectedItem() {
        guard let item = storage.getSelectedItemFromStorage() else { print("No item selected"); return }
        self.item = item
        toppingsCollectionView.getItem(item)
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
        if item?.category != .pizzas {
            itemDetailsView.hideDoughSegment()
        }
    }

    // Если размер один, то не нужно показывать поле с размерами, обновляем вес и цену товара
    func isOneSize() {
        if let oneSize = item?.itemSize.oneSize {
            itemDetailsView.hideSizeSegment()
            ingredientsView.updateWeight(oneSize.weight)
            cartButtonView.updatePrice(oneSize.price)
        }
    }

    func updateUIWithItem() {
        guard let item else { return }
        headerView.updateTitle(item.name)
        itemDetailsView.updatePizzaImage(item.imageName)
        ingredientsView.updateIngredients(item.ingredients)
        ingredientsView.updateWeight(item.itemSize.medium?.weight ?? 0)
        cartButtonView.updatePrice(item.itemSize.medium?.price ?? 0)
    }
}

// MARK: - Setup PopUpIngredientsView
private extension ProductDetailsViewController {

    func showPopupView() {
        showAnimatedPopupView()
        turningOffUserInteractionSegments()
        addGesture()
    }

    func turningOffUserInteractionSegments() {
        itemDetailsView.turningOffUserInteractionSegments()
    }

    func turningOnUserInteractionSegments() {
        itemDetailsView.turningOnUserInteractionSegments()
    }

    func showAnimatedPopupView() {
        view.addSubviews(infoPopupView)
        setupInfoPopupViewConstraints()

        let buttonFrame = ingredientsView.getButtonFrame()
        infoPopupView.frame = buttonFrame
        infoPopupView.isHidden = false

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    func addGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(hidePopupViewByTap))
        if let tapGesture {
            view.addGestureRecognizer(tapGesture)
        }
    }

    func removeGesture() {
        if let tapGesture {
            view.removeGestureRecognizer(tapGesture)
        }
    }

    @objc private func hidePopupViewByTap(_ sender: UIGestureRecognizer) {
        let location = sender.location(in: self.view)
        if !infoPopupView.frame.contains(location) {
            hidePopupView()
        }
    }

    @objc private func hidePopupView() {
        turningOnUserInteractionSegments()
        infoPopupView.isHidden = true
        removeGesture()
    }
}
