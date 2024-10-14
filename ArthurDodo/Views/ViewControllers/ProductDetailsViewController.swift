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
    private lazy var infoPopupView = InfoPopupView(pizza: pizza)
    private lazy var toppingsCollectionView = AddToppingsCollectionView()
    private lazy var cartButtonView = CartButtonViewFooter()

    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()

    // MARK: - Other Properties
    private let dataStorage = DataStorage.shared
    private var tapGesture: UITapGestureRecognizer?
    private var pizza: FoodItems?
    private var order: Order?

    var onCartButtonTapped: ( (Int) -> Void )?

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupInfoButtonTapped()
        setupHeader()

        updatePizzaData()
        setupSizeSegment()
        setupToppingsCollectionView()
        setupCartView()
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
    func getPizzaData(_ pizza: FoodItems) {
        self.pizza = pizza
    }

    // MARK: - Private methods
    private func updatePizzaData() {
        guard let pizza else { return }
        headerView.updateTitle(pizza.name)
        backgroundView.updatePizzaImage(pizza.imageName)
        infoView.updateIngredients(pizza.ingredients)

        if let pizza = pizza as? Pizza {
            infoView.updateWeight(pizza.itemSize[.medium]?.weight ?? 0)
            cartButtonView.updatePrice(pizza.itemSize[.medium]?.price ?? 0)
        }
    }

    private func setupUI() {
        view.backgroundColor = .black

        configScrollView()
        setupConstraints()
    }

    private func configScrollView() {
        view.addSubviews(scrollView, cartButtonView)

        scrollView.backgroundColor = .black
        scrollView.contentInsetAdjustmentBehavior = .never
        let bottomHeight = cartButtonView.getHeight() + 10
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomHeight, right: 0)

        scrollView.addSubviews(contentView)

        contentView.addSubviews(backgroundView, headerView, infoView, toppingsCollectionView)
    }

    private func setupHeader() {
        headerView.onCloseButtonTapped = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    private func setupToppingsCollectionView() {
        toppingsCollectionView.onToppingSelected = { [weak self] toppingPrice in
            guard let self else { return }
            var currentPrice = self.cartButtonView.getCurrentPrice()
            currentPrice += toppingPrice
            print(currentPrice)
            self.cartButtonView.updatePrice(currentPrice)
        }
    }

    private func setupCartView() {
        cartButtonView.isHidden = false
        cartButtonView.onCloseButtonTapped = { [weak self] finalPrice in
            guard let self,
                  let pizza else { return }
            let chosenSize = backgroundView.getChosenSize()
            let chosenDough = backgroundView.getChosenDough()

            var price = pizza.itemSize[.medium]?.price ?? 0

            if let pizza = pizza as? Pizza {
                price = pizza.itemSize[chosenSize]?.price ?? 0
            }

            order = Order(pizzaName: pizza.name, imageName: pizza.imageName, size: chosenSize, dough: chosenDough, price: price, isHit: pizza.isHit)
            guard let order else { return }
            dataStorage.sendToOrderStorage(order)
            self.onCartButtonTapped?(finalPrice)
            self.dismiss(animated: true)
        }
    }
}

// MARK: - Setup PopUpIngredientsView
extension ProductDetailsViewController {

    private func setupInfoButtonTapped() {
        infoView.onInfoButtonTapped = { [weak self] in
            guard let self else { return }
            if self.infoPopupView.isHidden {
                self.showPopupView()
            } else {
                self.hidePopupView()
            }
        }
    }

    private func setupSizeSegment() {
        backgroundView.onSegmentValueChanged = { [weak self] index in
            guard let self else { return }

            var size: Size = .small
            switch index {
            case 0: size = .small
            case 1: size = .medium
            case 2: size = .large
            default: break }

            let weight = self.pizza?.itemSize[size]?.weight ?? 0
            let price = self.pizza?.itemSize[size]?.price ?? 0
            self.infoView.updateWeight(weight)
            self.cartButtonView.updatePrice(price)
            self.infoPopupView.setSelectedSize(size)
        }
    }

    private func showPopupView() {
        showAnimatedPopupView()
        turningOffUserInteractionSegments()
        addGesture()
    }

    private func turningOffUserInteractionSegments() {
        backgroundView.turningOffUserInteractionSegments()
    }

    private func turningOnUserInteractionSegments() {
        backgroundView.turningOnUserInteractionSegments()
    }

    private func showAnimatedPopupView() {
        view.addSubviews(infoPopupView)
        setupInfoPopupViewConstraints()

        let buttonFrame = infoView.getButtonFrame()
        infoPopupView.frame = buttonFrame
        infoPopupView.isHidden = false

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    private func addGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(hidePopupViewByTap))
        if let tapGesture {
            view.addGestureRecognizer(tapGesture)
        }
    }

    private func removeGesture() {
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

        setupBackgroundViewConstraints()
        setupProductHeaderViewConstraints()
        setupInfoViewConstraints()
        setupToppingsCollectionViewConstraints()

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
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    private func setupProductHeaderViewConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    private func setupBackgroundViewConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    private func setupInfoViewConstraints() {
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 5),
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }

    private func setupInfoPopupViewConstraints() {
        let buttonFrame = infoView.getButtonFrame()

        NSLayoutConstraint.activate([
            infoPopupView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: buttonFrame.origin.x - 10),
            infoPopupView.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: buttonFrame.origin.y)
        ])
    }

    private func setupToppingsCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            toppingsCollectionView.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 5),
            toppingsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            toppingsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            toppingsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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
