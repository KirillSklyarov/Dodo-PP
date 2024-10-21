//
//  CustomSegmentControl.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 02.10.2024.
//

import UIKit

final class CustomSegmentControl: UISegmentedControl {

    // MARK: - Properties&Callbacks
    var onSegmentControllerValueChanged: ((Int) -> Void)?

//    private let viewHeight: CGFloat = 40
    private var leadingConstraint: NSLayoutConstraint?
    private lazy var selectedSegmentOval = UIView()

    // MARK: - Init
    init(items: [Any]?, defaultSelection: Int) {
        super.init(items: items)
        configSegmentControl(defaultSelection)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        moveOval(selectedSegmentIndex)
    }

    // MARK: - IB Action
    @objc private func sizeSegmentControlValueChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        moveOval(index)
        onSegmentControllerValueChanged?(index)
    }

    // MARK: - Private methods
    private func configSegmentControl(_ defaultSelection: Int) {
        setTitleTextAttributes([.font: AppFonts.medium16,
                                .foregroundColor: UIColor.white],
                               for: .normal)
        selectedSegmentIndex = defaultSelection
        setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)

//        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true

        addTarget(self, action: #selector(sizeSegmentControlValueChanged), for: .valueChanged)

        setupOvalLayout()
        setupLayout()
    }

    private func setupOvalLayout() {
        selectedSegmentOval.layer.cornerRadius = 20
        selectedSegmentOval.layer.masksToBounds = true
        selectedSegmentOval.translatesAutoresizingMaskIntoConstraints = false
        selectedSegmentOval.backgroundColor = .gray

        insertSubview(selectedSegmentOval, at: 1)
    }

    private func setupLayout() {
        leadingConstraint = selectedSegmentOval.leadingAnchor.constraint(equalTo: leadingAnchor)
        leadingConstraint?.isActive = true

        NSLayoutConstraint.activate([
            selectedSegmentOval.bottomAnchor.constraint(equalTo: bottomAnchor),
            selectedSegmentOval.topAnchor.constraint(equalTo: topAnchor),
            selectedSegmentOval.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0 / CGFloat(numberOfSegments))
        ])
    }

    private func moveOval(_ index: Int) {
        let segmentWidth = bounds.width / CGFloat(numberOfSegments)
        let segmentX = segmentWidth * CGFloat(index)

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            leadingConstraint?.constant = segmentX
            layoutIfNeeded()
        }
    }
}

