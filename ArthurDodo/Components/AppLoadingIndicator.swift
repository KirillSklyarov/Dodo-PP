//
//  appLoadingIndicator.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 25.10.2024.
//

import UIKit

final class AppLoadingIndicator: UIActivityIndicatorView {

    override init(style: UIActivityIndicatorView.Style = .large) {
        super.init(style: style)
        setupUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension AppLoadingIndicator {
    func setupUI() {
        color = UIColor.white
    }
}

// MARK: - Setup actions
extension AppLoadingIndicator {
    func showLoadingIndicator() {
        startAnimating()
        isHidden = false
    }

    func hideLoadingIndicator() {
        stopAnimating()
        isHidden = true
    }
}
