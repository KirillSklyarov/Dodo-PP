import UIKit

final class PreferredPaymentMethodTableView: UITableView {

    // MARK: - Properties
    private let cellHeight: CGFloat = 60
    private let cornerRadius: CGFloat = 10
    private let countOfRows = 1
    private var preferredPaymentMethod: PaymentMethod?

    var onCellSelected: (() -> Void)?

    // MARK: - Init
    init(frame: CGRect = .zero, style: UITableView.Style = .plain, _  preferredPaymentMethod: PaymentMethod) {
        super.init(frame: frame, style: style)
        self.preferredPaymentMethod = preferredPaymentMethod
        setupTableView()
        updateUI(with: preferredPaymentMethod)
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension PreferredPaymentMethodTableView {
    func updateUI(with preferredPaymentMethod: PaymentMethod) {
        self.preferredPaymentMethod = preferredPaymentMethod
        reloadData()
    }
}

// MARK: - Setup UI
private extension PreferredPaymentMethodTableView {
    func setupTableView() {
        backgroundColor = AppColors.backgroundGray
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        dataSource = self
        delegate = self
        registerCell(PreferredPaymentMethodTableViewCell.self)
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
extension PreferredPaymentMethodTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(indexPath) as PreferredPaymentMethodTableViewCell
        guard let preferredPaymentMethod else { return cell }
        let name = preferredPaymentMethod.title
        let image = preferredPaymentMethod.image
        cell.configureCell(title: name, image: image)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onCellSelected?()
    }
}
