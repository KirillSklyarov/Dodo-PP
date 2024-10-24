//
//  TestPopupView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 23.10.2024.
//

import UIKit

final class CpfcPopupView: UIViewController {

    // MARK: - Properties
    private let leftInsets: CGFloat = 10
    private let rightInsets: CGFloat = -20
    private let topInsets: CGFloat = 10
    private let bottomInset: CGFloat = -10

    private let cellHeight: CGFloat = 30
    private let cornerRadius: CGFloat = 20

    private let cpfcNames = CPFCData.allCases
    private var item: Item?
    private var productDetails: WeightPrice?

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.bold18
        label.numberOfLines = 0
        return label
    }()
    private lazy var subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.regular14
        label.text = "Пищевая ценность на 100 г"
        label.numberOfLines = 0
        return label
    }()
    private lazy var cpfcTableView: AppTableView = {
        let tableView = AppTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cpfcTableViewCell.self, forCellReuseIdentifier: cpfcTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.rowHeight = cellHeight
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        return tableView
    }()
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.regular14
        label.text = "Может содержать: глютен, молоко и продукты его переработки (в том числе лактозу), а так же некоторые другие аллергены"
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subLabel, cpfcTableView, infoLabel])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        return stack
    }()

    // MARK: - Init
    init(item: Item? = nil) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getItem(_ item: Item?) {
        if let item { self.item = item }
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }

    // MARK: - Public methods
    func setProductDetails(_ productDetails: WeightPrice) {
        self.productDetails = productDetails
        cpfcTableView.reloadData()
    }
}

extension CpfcPopupView {
    func setupPopupView(sourceView: UIView, sourceRect: CGRect) {
        modalPresentationStyle = .popover
        preferredContentSize = CGSize(width: 300, height: 310)
        popoverPresentationController?.sourceView = sourceView
        popoverPresentationController?.sourceRect = sourceRect
        popoverPresentationController?.permittedArrowDirections = .right
        popoverPresentationController?.delegate = sourceView as? UIPopoverPresentationControllerDelegate
    }
}

// MARK: - Setup UI
private extension CpfcPopupView {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStack)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.topAnchor, constant: topInsets),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInsets),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInsets),
            contentStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomInset),
        ])
    }
}

// MARK: - Update UI
private extension CpfcPopupView {
    func updateUI() {
        titleLabel.text = item?.name
        isOneSize()
    }

    // Если есть 1 размер, то показывай его
    func isOneSize() {
        if let oneSize = item?.itemSize.oneSize {
            productDetails = oneSize
        } else {
            productDetails = item?.itemSize.medium
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CpfcPopupView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cpfcNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cpfcTableViewCell.identifier, for: indexPath) as? cpfcTableViewCell else { return UITableViewCell() }
        guard let item = productDetails else { print("We have no productDetails"); return cell }

        let title = cpfcNames[indexPath.row]
        let value: String =
            switch title {
            case .weight: item.weight.description
            case .calories: item.cpfc.calories.description
            case .proteins: item.cpfc.protein.description
            case .fats: item.cpfc.fat.description
            case .carbohydrates: item.cpfc.carbohydrates.description
            }

        cell.configureCell(title: title.rawValue, cpfcValue: value)
        return cell
    }
}
