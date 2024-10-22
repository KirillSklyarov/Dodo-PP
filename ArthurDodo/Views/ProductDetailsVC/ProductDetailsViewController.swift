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
    private lazy var backgroundView = DetailsView()
    private lazy var infoView = IngredientsView()
    private lazy var infoPopupView = InfoPopupView(pizza: item)
    private lazy var toppingsCollectionView = AddToppingsCollectionView()
    private lazy var cartButtonView = CartButtonViewFooter()

    private lazy var infoAndToppingsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [infoView, toppingsCollectionView])
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
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [backgroundView, infoAndToppingsContainer])
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    private lazy var scrollView = UIScrollView()

    // MARK: - Other Properties
    private let dataStorage = DataStorage.shared
    private var tapGesture: UITapGestureRecognizer?
    private var item: Item?
    private var order: Order?

    var onCartButtonTapped: ( (Int) -> Void )?

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        updateItemData()
        isItemPizza()
        isOneSize()
    }

    // MARK: - IB Actions
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

    // MARK: - Public methods
    func getPizzaData(_ item: Item) {
        self.item = item
        toppingsCollectionView.getItem(item)
    }

    func isItemPizza() {
        if item?.category != .pizzas {
            backgroundView.hideDoughSegment()
        }
    }

    func isOneSize() {
        let countOfSizes = item?.itemSize.countOfSizes()
        if countOfSizes == 1 {
            backgroundView.hideSizeSegment()
        }
    }

    // MARK: - Private methods
    private func updateItemData() {
        guard let item else { return }
        headerView.updateTitle(item.name)
        backgroundView.updatePizzaImage(item.imageName)
        infoView.updateIngredients(item.ingredients)
        infoView.updateWeight(item.itemSize.medium?.weight ?? 0)
        cartButtonView.updatePrice(item.itemSize.medium?.price ?? 0)
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
        cartButtonView.onCloseButtonTapped = { [weak self] finalPrice in
            guard let self,
                  let item else { return }
            let chosenSize = backgroundView.getChosenSize()
            let chosenDough = backgroundView.getChosenDough()

            let price = item.itemSize.medium?.price ?? 0

//            if let pizza = item as? Pizza {
//                price = pizza.itemSize[chosenSize]?.price ?? 0
//            }

            order = Order(pizzaName: item.name, imageName: item.imageName, size: chosenSize, dough: chosenDough, price: price, isHit: item.isHit)
            guard let order else { return }
            dataStorage.sendToOrderStorage(order)
            self.onCartButtonTapped?(finalPrice)
            self.dismiss(animated: true)
        }
    }

    func setupSizeSegmentAction() {
        backgroundView.onSegmentValueChanged = { [weak self] index in
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
            self.infoView.updateWeight(weight)
            self.cartButtonView.updatePrice(price)
            self.infoPopupView.setProductDetails(productDetails)
        }
    }

    func setupInfoButtonAction() {
        infoView.onInfoButtonTapped = { [weak self] in
            guard let self else { return }
            if self.infoPopupView.isHidden {
                self.showPopupView()
            } else {
                self.hidePopupView()
            }
        }
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
        backgroundView.turningOffUserInteractionSegments()
    }

    func turningOnUserInteractionSegments() {
        backgroundView.turningOnUserInteractionSegments()
    }

    func showAnimatedPopupView() {
        view.addSubviews(infoPopupView)
        setupInfoPopupViewConstraints()

        let buttonFrame = infoView.getButtonFrame()
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
}

// MARK: - Constraints
extension ProductDetailsViewController {

    private func setupConstraints() {
        setupScrollViewConstraints()
        setupContentViewConstraints()
        setupProductHeaderViewConstraints()
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
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    private func setupProductHeaderViewConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func setupInfoPopupViewConstraints() {
        let buttonFrame = infoView.getButtonFrame()

        NSLayoutConstraint.activate([
            infoPopupView.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonFrame.origin.x - 10),
            infoPopupView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: buttonFrame.origin.y)
        ])
    }

    private func setupCartButtonConstraints() {
        NSLayoutConstraint.activate([
            cartButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cartButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupInfoAndToppingsStackConstraints() {
        NSLayoutConstraint.activate([
            infoAndToppingsStack.topAnchor.constraint(equalTo: infoAndToppingsContainer.topAnchor),
            infoAndToppingsStack.leadingAnchor.constraint(equalTo: infoAndToppingsContainer.leadingAnchor, constant: 10),
            infoAndToppingsStack.trailingAnchor.constraint(equalTo: infoAndToppingsContainer.trailingAnchor, constant: -10),
            infoAndToppingsStack.bottomAnchor.constraint(equalTo: infoAndToppingsContainer.bottomAnchor)
        ])
    }
}
