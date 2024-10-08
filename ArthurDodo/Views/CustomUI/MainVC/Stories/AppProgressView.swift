//
//  AppProgressView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 08.10.2024.
//

import UIKit

final class AppProgressView: UIProgressView {

    private let progressViewHeight: CGFloat = 4

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        progress = 0.0
//        trackTintColor = .red
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: progressViewHeight).isActive = true
    }
}
