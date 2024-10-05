//
//  ProfileVC.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 05.10.2024.
//

import UIKit

final class ProfileVC: UIViewController {

    private lazy var dismissButton = DismissProductView()
    private lazy var oneCollectionView = TestOneCollection()

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        dataBinding()
    }

    private func configUI() {
        view.backgroundColor = UIColor.black
        view.addSubviews(dismissButton, oneCollectionView)
        setupLayout()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            oneCollectionView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 10)
        ])
    }

    private func dataBinding() {
        dismissButton.onCloseButtonTapped = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
