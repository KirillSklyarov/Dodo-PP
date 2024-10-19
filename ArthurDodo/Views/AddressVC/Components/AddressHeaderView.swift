//
//  AddressHeaderView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 12.10.2024.
//

import UIKit

final class AddressHeaderView: UIStackView {

    private let leftPadding: CGFloat = 20
    private let rightPadding: CGFloat = -20
    private let topPadding: CGFloat = 10

    var onDismissButtonTapped: (() -> Void)?
    var onDeliveryButtonTapped: (() -> Void)?

    private lazy var dismissButton = DismissButtonView()
    private lazy var segmentControl: SegmentControlView = {
        let view = SegmentControlView(items: ["Доставка", "В пиццерии"], defaultSelection: 1)
        view.backgroundColor = AppColors.backgroundBlack
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
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

private extension AddressHeaderView {
    func setupUI() {
        axis = .horizontal
        spacing = 20

        addArrangedSubview(dismissButton)
        addArrangedSubview(segmentControl)
    }

    func setupLayout() {
        guard let superview else { print("You must add AddressHeaderView to a superview"); return }

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: topPadding),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leftPadding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: rightPadding)
        ])
    }
}

private extension AddressHeaderView {
    func setupActions() {
        setupDismissButtonAction()
        setupSegmentControlAction()
    }

    func setupDismissButtonAction() {
        dismissButton.onDismissButtonTapped = { [weak self] in
            self?.onDismissButtonTapped?()
        }
    }

    func setupSegmentControlAction() {
        segmentControl.onSegmentControllerValueChanged = { [weak self] segmentControlIndex in
            switch segmentControlIndex {
                case 0:
                self?.onDeliveryButtonTapped?()
            case 1:
                self?.onDismissButtonTapped?()
            default: break
            }
        }
    }
}
