//
//  SpecialOfferStackView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 10.10.2024.
//

import UIKit

final class SpecialOfferStackView: UIStackView {

    // MARK: - Properties
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10

    private lazy var specialOfferHeaderView = OrderView(title: "Акции")
    private lazy var specialOfferCollectionView = CartSpOfferCollection()
    private lazy var pageControl = CustomPageControl()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupSpecialOfferCollectionViewActions()
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
}

// MARK: - Setup Actions
extension SpecialOfferStackView {
    func setupSpecialOfferCollectionViewActions() {
        specialOfferCollectionView.onShowNewCell = { [weak self] pageNumber in
            self?.pageControl.currentPage = pageNumber
        }
    }
}

// MARK: - Setup UI
extension SpecialOfferStackView {
    func setupUI() {
        addArrangedSubview(specialOfferHeaderView)
        addArrangedSubview(specialOfferCollectionView)
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
