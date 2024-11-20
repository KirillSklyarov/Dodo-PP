import UIKit

final class DeliveryTableView: UITableView {

    // MARK: - Properties
    private let cellHeight: CGFloat = 60
    private let countOfRows = 1
    private var name = ""

    var onCellSelected: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension DeliveryTableView {
    func updateUI(with addressName: String) {
        self.name = addressName
        reloadData()
    }
}

// MARK: - Setup UI
private extension DeliveryTableView {
    func setupTableView() {
        backgroundColor = .clear
        dataSource = self
        delegate = self
        registerCell(DeliveryTableViewCell.self)
        rowHeight = cellHeight
        separatorStyle = .none
        tableHeaderView = UIView(frame: .zero)

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
        let cell = tableView.dequeueCell(indexPath) as DeliveryTableViewCell
        cell.configureCell(name)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onCellSelected?()
    }
}
