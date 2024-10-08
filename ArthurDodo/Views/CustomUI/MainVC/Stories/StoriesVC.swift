//
//  StoriesVC.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 07.10.2024.
//

import UIKit

final class StoriesVC: UIViewController {

    private lazy var backgroundView = BackgroundStoriesView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        dataBinding()
    }

    private func dataBinding() {
        backgroundView.onDismissButtonTapped = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    func showStories(_ indexPath: IndexPath) {
        backgroundView.showStories(indexPath)
    }
}

private extension StoriesVC {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack

        view.addSubviews(backgroundView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
