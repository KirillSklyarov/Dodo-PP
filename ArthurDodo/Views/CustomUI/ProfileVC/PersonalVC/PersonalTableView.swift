//
//  PersonalTableView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 11.10.2024.
//

import UIKit

enum PersonalData: Int, CaseIterable {
    case name
    case phone
    case email
    case dateOfBirth
    case agreeOfSending

    var title: String {
        switch self {
        case .name: return "Имя"
        case .phone: return "Телефон"
        case .email: return "Почта"
        case .dateOfBirth: return "День рождения"
        case .agreeOfSending: return "Разрешить уведомления"
        }
    }
}

final class PersonalTableView: UITableView {

    // MARK: - Properties&Callbacks
    private let tableRowHeightSection1: CGFloat = 80
    private let tableRowHeightSection2: CGFloat = 60

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
        register(PersonalTableViewCell.self, forCellReuseIdentifier: PersonalTableViewCell.identifier)
        register(LegalSectionTableViewCell.self, forCellReuseIdentifier: LegalSectionTableViewCell.identifier)
        register(QuitProfileTableViewCell.self, forCellReuseIdentifier: QuitProfileTableViewCell.identifier)

        separatorStyle = .singleLine
        separatorColor = .darkGray
        separatorInset = .init(top: 0, left: 10, bottom: 0, right: 0)
        tableHeaderView = UIView(frame: .zero)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PersonalTableView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return PersonalData.allCases.count
        case 1: return 2
        case 2: return 1
        case 3: return 1
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section

        switch section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonalTableViewCell.identifier, for: indexPath) as? PersonalTableViewCell else { print("rrrr"); return UITableViewCell() }
            guard let row = PersonalData(rawValue: indexPath.row) else { return UITableViewCell() }
            let cellName = row.title
            let cellData = getRowDataFromModel(row, testUser)
            cell.configureCell(title: cellName, data: cellData)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LegalSectionTableViewCell.identifier, for: indexPath) as? LegalSectionTableViewCell else { print("rrrr"); return UITableViewCell() }
            let row = indexPath.row
            cell.configureCell(row)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: QuitProfileTableViewCell.identifier, for: indexPath) as? QuitProfileTableViewCell else { print("rrrr"); return UITableViewCell() }
            let title = "Выйти из профиля"
            cell.configureCell(title)
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: QuitProfileTableViewCell.identifier, for: indexPath) as? QuitProfileTableViewCell else { print("rrrr"); return UITableViewCell() }
            let title = "Удалить профиль"
            cell.configureCell(title, UIColor.red)
            return cell
        default: return UITableViewCell()
        }
    }

    func getRowDataFromModel(_ row: PersonalData, _ data: UserModel) -> String {
        switch row {
        case .name: return data.name
        case .phone: return data.phone
        case .email: return data.email
        case .dateOfBirth: return data.dateOfBirth
        case .agreeOfSending: return data.agreeOfSending.description
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section

        switch section {
        case 0: return tableRowHeightSection1
        default: return tableRowHeightSection2
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = AppColors.buttonGray
        return footer
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        15
    }
}
