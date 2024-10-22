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
    private var tableViewHeight: CGFloat { cellHeight * CGFloat(data.count) }

    private let data = CPFCData.allCases
    private var pizza: Item?
    private var productDetails: WeightPrice?

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.bold18
        label.text = "Сырная"
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

    // MARK: - Init
    init(frame: CGRect = .zero, pizza: Item?) {
        super.init(frame: frame)
        self.pizza = pizza
        setupView()
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

    func setupView() {
        isHidden = true
        backgroundColor = .black
        layer.cornerRadius = 20
        layer.masksToBounds = true
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        widthAnchor.constraint(equalToConstant: viewWidth).isActive = true

        setupLayout()
    }

    func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subLabel, cpfcTableView, infoLabel])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 5

        addSubviews(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension InfoPopupView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cpfcTableViewCell.identifier, for: indexPath) as? cpfcTableViewCell else { return UITableViewCell() }
        guard let item = productDetails else { print("Jopa"); return cell }

//        guard let item = selectedSize
//        else { print("Jopa"); return cell }
        let title = data[indexPath.row]
        print("title \(title)")
        let valueString: String =
        switch title {
        case .weight: item.weight.description
        case .calories: item.cpfc.calories.description
        case .proteins: item.cpfc.protein.description
        case .fats: item.cpfc.fat.description
        case .carbohydrates: item.cpfc.carbohydrates.description
        }
        cell.configureCell(title: title.rawValue, cpfcValue: valueString)
        return cell
    }
}