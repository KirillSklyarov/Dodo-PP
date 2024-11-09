import UIKit

final class PaymentAddressesTableView: AppTableView {

    // MARK: - Properties&Callbacks
    private let tableRowHeight: CGFloat = 70
    private let cornerRadius: CGFloat = 10

    var preferredPaymentMethod: PaymentMethod = .cbp
    var onPaymentMethodTapped: ( (PaymentMethod) -> Void)?

    // MARK: - Init
    init(frame: CGRect = .zero, style: UITableView.Style = .plain, preferredPaymentMethod: PaymentMethod) {
        super.init(frame: frame, style: style)
        configTableView()
        self.preferredPaymentMethod = preferredPaymentMethod
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updatePreferredPaymentMethod(_ paymentMethod: PaymentMethod) {
        preferredPaymentMethod = paymentMethod
        reloadData()
    }
}

// MARK: - Supporting methods
private extension PaymentAddressesTableView {
    // Сохраняем выбранный способ оплаты в UserDefaults
    func setPreferredPaymentMethodToUserDefaults(_ paymentMethod: PaymentMethod) {
        UserDefaults.standard.setPreferredPaymentMethod(paymentMethod)
    }
}

// MARK: - Setup UI
private extension PaymentAddressesTableView {
    func configTableView() {
        backgroundColor = AppColors.backgroundGray
        dataSource = self
        delegate = self
        register(PaymentMethodsTableViewCell.self, forCellReuseIdentifier: PaymentMethodsTableViewCell.identifier)
        separatorStyle = .singleLine
        separatorColor = .darkGray
        separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableHeaderView = UIView(frame: .zero)
        rowHeight = tableRowHeight
        isScrollEnabled = false
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}

// MARK: - Setup action
private extension PaymentAddressesTableView {
    func setupActions() {

    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PaymentAddressesTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PaymentMethod.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodsTableViewCell.identifier, for: indexPath) as? PaymentMethodsTableViewCell else { print("rrrr"); return UITableViewCell() }
        guard let paymentMethod = PaymentMethod(rawValue: indexPath.row) else {
            print("We don't have payment method"); return UITableViewCell()}

        let paymentMethodName = paymentMethod.title
        let paymentMethodImage = paymentMethod.image
        let isMainMethod = (paymentMethod == preferredPaymentMethod)
        cell.configureCell(title: paymentMethodName, image: paymentMethodImage, isMainMethod: isMainMethod)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let paymentMethod = PaymentMethod(rawValue: indexPath.row) else {
            print("We don't have payment method"); return }
        onPaymentMethodTapped?(paymentMethod)
        setPreferredPaymentMethodToUserDefaults(paymentMethod)
    }
}
