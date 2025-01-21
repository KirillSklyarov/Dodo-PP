import UIKit
import AppUIComponentsSPM

final class AddressListTableView: AppTableView {

    // MARK: - Properties&Callbacks
    private let tableRowHeight: CGFloat = 65
    private var addresses: [Address] = []

    var onEditAddressButtonTapped: ( (Address) -> Void)?
    var onCellTapped: ( (Address) -> Void)?

    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getAddresses(_ addresses: [Address]) {
        self.addresses = addresses
        reloadData()
    }
}

// MARK: - Setup tableView
private extension AddressListTableView {
     func configTableView() {
        backgroundColor = .clear
        dataSource = self
        delegate = self
        registerCell(AddressListTableViewCell.self)

        separatorStyle = .singleLine
        separatorColor = .darkGray
        separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        rowHeight = tableRowHeight
        isScrollEnabled = false
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AddressListTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addresses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(indexPath) as AddressListTableViewCell
        let address = addresses[indexPath.row]
        let addressName = address.name
        let isMain = address.isMain
        cell.configureCell(title: addressName, isMain: isMain)

        cell.onEditAddressButtonTapped = { [weak self] in
            guard let self else { return }
            let address = addresses[indexPath.row]
            onEditAddressButtonTapped?(address)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AddressListTableViewCell else { return }
        deselectMainAddress(indexPath: indexPath, tableView: tableView)
        cell.selectedCell()
        onCellTapped?(addresses[indexPath.row])
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AddressListTableViewCell else { return }
        cell.deSelectedCell()
    }

    // Этот метод пустой, потому что мы "включили" сепаратор у последней ячейки (в классе AppTableView он выключен)
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}

// MARK: - Supporting methods
private extension AddressListTableView {
    // Убираем выделение с первой ячейки (она же основная)
    func deselectMainAddress(indexPath: IndexPath, tableView: UITableView) {
        if indexPath.row != 0 {
            let firstIndexPath = IndexPath(row: 0, section: 0)
            let firstCell = tableView.cellForRow(at: firstIndexPath) as? AddressListTableViewCell
            firstCell?.deSelectedCell()
        }
    }
}
