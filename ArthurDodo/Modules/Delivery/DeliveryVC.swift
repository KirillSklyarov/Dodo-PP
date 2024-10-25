import UIKit

final class DeliveryVC: UIViewController {

    // MARK: - UI Properties
    private lazy var addressTableView = DeliveryTableView()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Время доставки"
        label.font = AppFonts.semibold20
        label.textColor = .white
        return label
    }()

    private lazy var paymentLabel: UILabel = {
        let label = UILabel()
        label.text = "Оплата"
        label.font = AppFonts.semibold20
        label.textColor = .white
        return label
    }()

    private lazy var paymentTableView = DeliveryTableView()

    private lazy var payButton = CartButtonView()

    private let topInset: CGFloat = 10
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let bottomInset: CGFloat = -10

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Setup UI
private extension DeliveryVC {
    func setupUI() {
        setupNavigationBar()
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(addressTableView, timeLabel, paymentLabel, paymentTableView, payButton)

        setupLayout()
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = AppColors.backgroundGray
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationItem.title = "Доставка"

        let dismissButton = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(dismissButtonTapped))
        dismissButton.tintColor = AppColors.buttonOrange
        dismissButton.setTitleTextAttributes([NSAttributedString.Key .font: AppFonts.semibold18], for: .normal)
        navigationItem.leftBarButtonItem = dismissButton
    }

    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }

    func setupLayout() {
        setupAddressTableLayout()
        setupTimeLabelLayout()
        setupPaymentLabelLayout()
        setupPaymentTableLayout()
        setupPayButtonLayout()
    }

    func setupAddressTableLayout() {
        NSLayoutConstraint.activate([
            addressTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topInset),
            addressTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            addressTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset)
        ])
    }

    func setupTimeLabelLayout() {
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: addressTableView.bottomAnchor, constant: topInset*3),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset)
        ])
    }

    func setupPaymentLabelLayout() {
        NSLayoutConstraint.activate([
            paymentLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: topInset*3),
            paymentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            paymentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset)
        ])
    }

    func setupPaymentTableLayout() {
        NSLayoutConstraint.activate([
            paymentTableView.topAnchor.constraint(equalTo: paymentLabel.bottomAnchor, constant: topInset),
            paymentTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            paymentTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset)
        ])
    }

    func setupPayButtonLayout() {
        NSLayoutConstraint.activate([
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomInset),
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset)
        ])
    }
}

//MARK: - SwiftUI
import SwiftUI
struct ProviderDelivery: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }

    struct ContainterView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return DeliveryVC()
        }

        typealias UIViewControllerType = UIViewController


        let viewController = DeliveryVC()
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProviderDelivery.ContainterView>) -> DeliveryVC {
            return viewController
        }

        func updateUIViewController(_ uiViewController: ProviderDelivery.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProviderDelivery.ContainterView>) {

        }
    }
}
