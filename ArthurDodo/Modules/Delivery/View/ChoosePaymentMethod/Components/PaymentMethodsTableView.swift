import UIKit

final class PaymentMethodsTableView: AppTableView {

    // MARK: - Properties&Callbacks
    private let tableRowHeight: CGFloat = 70
    private let cornerRadius: CGFloat = 10

    var preferredPaymentMethod: PaymentMethod?
    var onPaymentMethodTapped: ( (PaymentMethod) -> Void)?

    // MARK: - Init
    override init(frame: CGRect = .zero, style: UITableView.Style = .plain) {
        super.init(frame: frame, style: style)
        configTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Public methods
extension PaymentMethodsTableView {
    func updatePreferredPaymentMethod(_ paymentMethod: PaymentMethod) {
        preferredPaymentMethod = paymentMethod
        reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

// MARK: - Setup UI
private extension PaymentMethodsTableView {
    func configTableView() {
        backgroundColor = AppColors.backgroundGray
        dataSource = self
        delegate = self
        registerCell(PaymentMethodsTableViewCell.self)
        separatorColor = .darkGray
        rowHeight = tableRowHeight
        isScrollEnabled = false
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PaymentMethodsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PaymentMethod.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(indexPath) as PaymentMethodsTableViewCell
        configureCell(cell, at: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let paymentMethod = PaymentMethod(rawValue: indexPath.row) else {
            print("We don't have payment method"); return }
        onPaymentMethodTapped?(paymentMethod)
    }
}

// MARK: - Supporting methods
private extension PaymentMethodsTableView {
    func configureCell(_ cell: PaymentMethodsTableViewCell, at indexPath: IndexPath) {
        guard let paymentMethod = PaymentMethod(rawValue: indexPath.row) else {
            print("We don't have payment method"); return }
        let paymentMethodName = paymentMethod.title
        let paymentMethodImage = paymentMethod.image
        let isMainMethod = (paymentMethod == preferredPaymentMethod)
        cell.configureCell(title: paymentMethodName, image: paymentMethodImage, isMainMethod: isMainMethod)
    }
}
