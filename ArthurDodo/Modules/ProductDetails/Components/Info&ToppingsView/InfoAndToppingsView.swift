//
//  InfoAndToppingsView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 15.10.2024.
//

import UIKit

final class InfoAndToppingsStack: UIStackView {

    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10

    private lazy var infoView = IngredientsView()
    private lazy var toppingsCollectionView = AddToppingsCollectionView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

private extension InfoAndToppingsStack {
    func setupUI() {
        addArrangedSubview(infoView)
        addArrangedSubview(toppingsCollectionView)
        axis = .vertical
        spacing = 5

//        setupLayout()
    }

//    func setupLayout() {
//        NSLayoutConstraint.activate([
//            InfoAndToppingsStack.topAnchor.constraint(equalTo: topAnchor),
//            infoAndToppingsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInset),
//            infoAndToppingsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightInset),
//            infoAndToppingsStack.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//    }
}
