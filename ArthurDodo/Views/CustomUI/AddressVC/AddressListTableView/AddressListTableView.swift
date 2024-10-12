//
//  AddressListTableView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 12.10.2024.
//

import UIKit

final class AddressListTableView: UITableView {

    // MARK: - Properties&Callbacks
    private let tableRowHeight: CGFloat = 80

    var onShowURL: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func configTableView() {
        backgroundColor = .clear
        dataSource = self
        delegate = self
        register(AddressListTableViewCell.self, forCellReuseIdentifier: AddressListTableViewCell.identifier)

        separatorStyle = .singleLine
        separatorColor = .darkGray
        separatorInset = .init(top: 0, left: 10, bottom: 0, right: 0)
        tableHeaderView = UIView(frame: .zero)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AddressListTableView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myAddresses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressListTableViewCell.identifier, for: indexPath) as? AddressListTableViewCell else { print("rrrr"); return UITableViewCell() }
        let addressName = myAddresses[indexPath.row].name
        cell.configureCell(title: addressName)
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableRowHeight
    }
}
