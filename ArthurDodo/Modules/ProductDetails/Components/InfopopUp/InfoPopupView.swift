//
//  InfoPopupView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 20.09.2024.
//

import UIKit

final class InfoPopupView: UIView {

    // MARK: - Properties
    private let viewHeight: CGFloat = 300
    private let viewWidth: CGFloat = 300
    private let cellHeight: CGFloat = 30
    private var tableViewHeight: CGFloat { cellHeight * CGFloat(cpfcNames.count) }
    private let leftInsets: CGFloat = 10
    private let rightInsets: CGFloat = -10
    private let topInsets: CGFloat = 10
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
    private lazy var cpfcTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cpfcTableViewCell.self, forCellReuseIdentifier: cpfcTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.rowHeight = cellHeight
        tableView.isScrollEnabled = false
        tableView.heightAnchor.constraint(equalToConstant: tableViewHeight).isActive = true
        return tableView
    }()
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.text = "Может содержать: глютен, молоко и продукты его переработки (в том числе лактозу), а так же некоторые другие аллергены"
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subLabel, cpfcTableView, infoLabel])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 5
        return stack
    }()

    // MARK: - Init
    init(frame: CGRect = .zero, item: Item?) {
        super.init(frame: frame)
        self.item = item
        setupUI()
        updateUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func setProductDetails(_ productDetails: WeightPrice) {
        self.productDetails = productDetails
        cpfcTableView.reloadData()
    }
}

// MARK: - Setup UI
private extension InfoPopupView {
    func setupUI() {
        isHidden = true
        backgroundColor = AppColors.backgroundBlack
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        widthAnchor.constraint(equalToConstant: viewWidth).isActive = true

        setupLayout()
    }

    func setupLayout() {
        addSubviews(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: topInsets),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInsets),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightInsets)
        ])
    }
}

// MARK: - Update UI
private extension InfoPopupView {
    func updateUI() {
        titleLabel.text = item?.name
        isOneSize()
    }

    // Если есть 1 размер, то показывай его
    func isOneSize() {
        if let oneSize = item?.itemSize.oneSize {
            productDetails = oneSize
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension InfoPopupView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cpfcNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cpfcTableViewCell.identifier, for: indexPath) as? cpfcTableViewCell else { return UITableViewCell() }
        guard let item = productDetails else { print("Jopa"); return cell }

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
