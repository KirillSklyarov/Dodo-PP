import UIKit

final class AddressListTableView: AppTableView {

    // MARK: - Properties&Callbacks
    private let tableRowHeight: CGFloat = 70
    private let storage = DataStorage.shared

    var onEditAddressButtonTapped: ( (IndexPath) -> Void)?

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
        separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableHeaderView = UIView(frame: .zero)
        rowHeight = tableRowHeight
        isScrollEnabled = false
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AddressListTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        storage.fetchedUserAddresses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressListTableViewCell.identifier, for: indexPath) as? AddressListTableViewCell else { print("rrrr"); return UITableViewCell() }
        let address = storage.fetchedUserAddresses[indexPath.row]
        let addressName = address.name
        let isMain = address.isMain
        cell.configureCell(title: addressName, isMain: isMain)

        cell.onEditAddressButtonTapped = { [weak self] in
            self?.onEditAddressButtonTapped?(indexPath)
        }
        
        return cell
    }
}
