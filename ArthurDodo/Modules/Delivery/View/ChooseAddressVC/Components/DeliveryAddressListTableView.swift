import UIKit

final class DeliveryAddressListTableView: UITableView {

    // MARK: - Properties&Callbacks
    private let tableRowHeight: CGFloat = 70

    var addresses: [Address] = []
    var addressNames: [String] = []

    var onAddressCellTapped: ( (String) -> Void)?
    var onEditAddressButtonTapped: ( (IndexPath) -> Void)?
    var onAddNewAddressCellTapped: ( () -> Void)?

    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI(with addresses: [Address]) {
        getAddresses(addresses)
        updateHeight()
    }
}

// MARK: - Supporting methods
private extension DeliveryAddressListTableView {
    func getAddresses(_ addresses: [Address]) {
        self.addresses = addresses
        addressNames = addresses.map(\.name)
        addressNames.append("Добавить новый адрес")
    }

    func updateHeight() {
        reloadData()
        let tableHeight = contentSize.height
        heightAnchor.constraint(equalToConstant: tableHeight).isActive = true
    }
}

// MARK: - Setup action
private extension DeliveryAddressListTableView {
    func setupActions() {

    }
}

// MARK: - Setup UI
private extension DeliveryAddressListTableView {
    func configTableView() {
        backgroundColor = .clear
        dataSource = self
        delegate = self
        registerCell(AddressListTableViewCell.self)

        separatorStyle = .singleLine
        separatorColor = .darkGray
        separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableHeaderView = UIView(frame: .zero)
        rowHeight = tableRowHeight
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DeliveryAddressListTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addressNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(indexPath) as AddressListTableViewCell
        let addressName = addressNames[indexPath.row]
        if indexPath.row != addressNames.count - 1 {
            let isMain = addresses[indexPath.row].isMain
            cell.configureCell(title: addressName, isMain: isMain)
        } else {
            cell.configureLastCell(title: addressName)
        }

        cell.onEditAddressButtonTapped = { [weak self] in
            self?.onEditAddressButtonTapped?(indexPath)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != addressNames.indices.last {
            let addressName = addressNames[indexPath.row]
            onAddressCellTapped?(addressName)
        } else {
            onAddNewAddressCellTapped?()
        }
    }
}
