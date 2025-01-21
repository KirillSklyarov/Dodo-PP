import UIKit
import AppUIComponentsSPM

final class PersonalTableView: UITableView {

    // MARK: - Properties&Callbacks
    private let tableRowHeightSection1: CGFloat = 75
    private let tableRowHeightSection2: CGFloat = 55
    private let footerHeight: CGFloat = 12

    private var userData: User?

    var onShowURL: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getUserData(_ userData: User) {
        self.userData = userData
        reloadData()
    }

    // MARK: - Private methods
    private func configTableView() {
        backgroundColor = .clear
        dataSource = self
        delegate = self
        registerCell(PersonalTableViewCell.self)
        registerCell(LegalSectionTableViewCell.self)
        registerCell(QuitProfileTableViewCell.self)

        separatorStyle = .singleLine
        separatorColor = .darkGray
        separatorInset = .init(top: 0, left: 10, bottom: 0, right: 0)
        tableHeaderView = UIView(frame: .zero)
        isScrollEnabled = false
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
            let cell = tableView.dequeueCell(indexPath) as PersonalTableViewCell
            guard let row = PersonalData(rawValue: indexPath.row),
                  let userData else { return UITableViewCell() }
            let cellName = row.title
            let cellData = getRowDataFromModel(row, userData)
            cell.configureCell(title: cellName, data: cellData)
            return cell
        case 1:
            let cell = tableView.dequeueCell(indexPath) as LegalSectionTableViewCell
            let row = indexPath.row
            cell.configureCell(row)
            return cell
        case 2:
            let cell = tableView.dequeueCell(indexPath) as QuitProfileTableViewCell
            let title = "Выйти из профиля"
            cell.configureCell(title)
            return cell
        case 3:
            let cell = tableView.dequeueCell(indexPath) as QuitProfileTableViewCell
            let title = "Удалить профиль"
            cell.configureCell(title, UIColor.red)
            return cell
        default: return UITableViewCell()
        }
    }

    func getRowDataFromModel(_ row: PersonalData, _ data: User) -> String {
        switch row {
        case .name: return data.firstName
        case .phone: return data.phoneNumber
        case .email: return data.email
        case .dateOfBirth: return data.dateOfBirth
        case .agreeOfSending: return data.agreeOfSending.description
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section

        switch section {
        case 1: onShowURL?()
        default: break
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
        footerHeight
    }
}
