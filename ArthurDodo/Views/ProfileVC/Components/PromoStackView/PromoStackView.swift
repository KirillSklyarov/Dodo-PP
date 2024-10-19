//
//  SpecialOfferStackView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 10.10.2024.
//

import UIKit

final class PromoStackView: UIStackView {

    // MARK: - Properties
    private let leftPadding: CGFloat = 0
    private let rightPadding: CGFloat = 0

    var onPromoSelected: ((Promo) -> Void)?

    private lazy var promoHeaderView = OrderView(title: "Акции")
    private lazy var promoCollectionView = PromoCollectionView()
    private lazy var pageControl = CustomPageControl()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupPromoCollectionViewActions()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            setupLayout()
        }
    }

    func updateUI(_ promo: [Promo]) {
        promoCollectionView.updateUI(promo)
    }
}

// MARK: - Setup Actions
extension PromoStackView {
    func setupPromoCollectionViewActions() {
        promoCollectionView.onShowNewCell = { [weak self] pageNumber in
            self?.pageControl.currentPage = pageNumber
        }

        promoCollectionView.onCellSelected = { [weak self] specialOffer in
            self?.onPromoSelected?(specialOffer)
        }
    }
}

// MARK: - Setup UI
extension PromoStackView {
    func setupUI() {
        addArrangedSubview(promoHeaderView)
        addArrangedSubview(promoCollectionView)
        addArrangedSubview(pageControl)

        axis = .vertical
        spacing = 10
    }

    func setupLayout() {
        guard let superview else { print("You must add superview to MissionStackView"); return }

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leftPadding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: rightPadding),
        ])
    }
}
