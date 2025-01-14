final class PaymentMethodConfigurator {
    // MARK: - Properties
    private let storage: DeliveryStorage

    // MARK: - Init
    init(storage: DeliveryStorage) {
        self.storage = storage
    }

    // MARK: - Methods
    func configure() -> ChoosePaymentMethodVC {
        let presenter = ChoosePaymentMethodPresenter(storage: storage)
        let view = ChoosePaymentMethodVC(output: presenter)

        presenter.view = view

        return view
    }
}
