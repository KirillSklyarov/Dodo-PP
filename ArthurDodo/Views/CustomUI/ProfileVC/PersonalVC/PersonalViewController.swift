//
//  PersonalViewController.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 11.10.2024.
//

import UIKit

final class PersonalViewController: UIViewController {

    private lazy var personalTableView = PersonalTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }
}

// MARK: - Setup UI
private extension PersonalViewController {
    func setupUI() {
        title = "Настройки"
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(personalTableView)

        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            personalTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            personalTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            personalTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            personalTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = AppColors.backgroundGray
        navigationController?.navigationBar.backgroundColor = AppColors.backgroundGray

        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = AppColors.buttonOrange
        doneButton.setTitleTextAttributes([NSAttributedString.Key .font: AppFonts.semibold18], for: .normal)
        navigationItem.rightBarButtonItem = doneButton
    }

    @objc func doneButtonTapped() {
        dismiss(animated: true)
    }
}
