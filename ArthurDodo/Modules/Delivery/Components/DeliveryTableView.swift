import UIKit

final class DeliveryTableView: UITableView {

    // MARK: - Properties
    private let cellHeight: CGFloat = 60
    private let countOfRows = 1

    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension DeliveryTableView {
    func setupTableView() {
        backgroundColor = .clear
        dataSource = self
        delegate = self
        register(DeliveryTableViewCell.self, forCellReuseIdentifier: DeliveryTableViewCell.identifier)
        rowHeight = cellHeight

        setupLayout()
    }

    func setupLayout() {
        heightAnchor.constraint(equalToConstant: cellHeight).isActive = true
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DeliveryTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryTableViewCell.identifier, for: indexPath) as? DeliveryTableViewCell else { return UITableViewCell() }
        return cell
    }
}
