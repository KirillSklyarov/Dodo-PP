//
//  MainViewController.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 05.10.2024.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var dismissButton = DismissProductView()
    private lazy var oneCollectionView = TestOneCollection()
    private lazy var headerView = HeaderView()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        dataBinding()
    }
}

// MARK: - SetupDataBinding
private extension MainViewController {
    func dataBinding() {
        setupCollectionView()
    }

    func setupCollectionView() {
        oneCollectionView.onItemCellTapped = { [weak self] item in
            self?.showProductDetail(item)
        }
    }

    func showProductDetail(_ pizza: FoodItems) {
        let productDetailVC = ProductDetailsViewController()
        productDetailVC.getPizzaData(pizza)
        productDetailVC.modalPresentationStyle = .overFullScreen
        productDetailVC.isModalInPresentation = false
        present(productDetailVC, animated: true)
    }
}

// MARK: - SetupLayout
private extension MainViewController {
    func configUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(headerView, oneCollectionView)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            oneCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10)
        ])
    }
}
