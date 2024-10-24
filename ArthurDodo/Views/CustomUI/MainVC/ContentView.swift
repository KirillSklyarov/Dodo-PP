//
//  ContentView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 03.10.2024.
//

import UIKit

final class CustomContentView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        setupLayout()
    }

    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
//        backgroundColor = .systemGreen
    }

    func setupLayout() {
        guard let superview else { print("You must add CustomContentView to a superview"); return }

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),

            widthAnchor.constraint(equalTo: superview.widthAnchor),
//            heightAnchor.constraint(equalToConstant: 4100)
        ])
    }
}
