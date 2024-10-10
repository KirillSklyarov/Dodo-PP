//
//  MissionStackView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 10.10.2024.
//

import UIKit

final class MissionStackView: UIStackView {

    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10

    private lazy var missionHeaderView = OrderView(title: "Миссии")
    private lazy var missionView = MissionView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
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

    func setupUI() {
        addArrangedSubview(missionHeaderView)
        addArrangedSubview(missionView)

        axis = .vertical
        spacing = 10
    }

    func setupLayout() {
        guard let superview else { print("You must add superview to MissionStackView"); return }

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leftPadding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: rightPadding),
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
