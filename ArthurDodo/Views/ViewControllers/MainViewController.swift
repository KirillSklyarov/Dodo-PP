//
//  MainViewController.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 05.10.2024.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = HeaderView()
    private lazy var contentCollectionView = ContentCollectionView()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        dataBinding()
    }
}

// MARK: - Setup DataBinding
private extension MainViewController {
    func dataBinding() {
        setupCollectionView()
    }

    func setupCollectionView() {
        contentCollectionView.onItemCellTapped = { [weak self] item in
            self?.showProductDetail(item)
        }

        contentCollectionView.onStoriesCellTapped = { [weak self] IndexPath in
            self?.showStoriesVC(IndexPath)
        }
    }

    func showProductDetail(_ pizza: FoodItems) {
        let productDetailVC = ProductDetailsViewController()
        productDetailVC.getPizzaData(pizza)
        productDetailVC.modalPresentationStyle = .overFullScreen
        productDetailVC.isModalInPresentation = false
        present(productDetailVC, animated: true)
    }

    func showStoriesVC(_ indexPath: IndexPath) {
        let storiesVC = StoriesVC()
        storiesVC.showStories(indexPath)
        storiesVC.modalPresentationStyle = .overFullScreen
        storiesVC.isModalInPresentation = false
        present(storiesVC, animated: true)
    }
}

// MARK: - SetupLayout
private extension MainViewController {
    func configUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(headerView, contentCollectionView)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10)
        ])
    }
}
