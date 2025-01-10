import Foundation

final class ChooseAddressPresenter {

    // MARK: - Properties
    private var addresses: [Address]?

    var onAddressCellTapped: ((String) -> Void)?
    var onEditAddressCellTapped: ( (Address) -> Void)?
    var onShowAddNewAddress: (() -> Void)?

    private let router: ChooseAddressRouterInput
    private let storageService: DataStorageService

    weak var view: ChooseAddressViewInput?

    // MARK: - Init
    init(router: ChooseAddressRouterInput, storageService: DataStorageService) {
        self.router = router
        self.storageService = storageService
    }
}

// MARK: - ChooseAddressViewOutput
extension ChooseAddressPresenter: ChooseAddressViewOutput {
    func viewLoaded() {
        view?.setInitialState()
        loadData()
    }

    func sendAction(_ action: ChooseAddressViewModelAction) {
        switch action {
        case .dismissButtonTapped: router.dismiss()
        case .addressCellTapped(let addressName): addressCellTapped(addressName)
        case .editAddressCellTapped(let indexPath): editAddressCellTapped(indexPath)
        case .addNewAddressButtonTapped: addNewAddressButtonTapped()
        }
    }
}

// MARK: - Fetch Data
private extension ChooseAddressPresenter {
    func loadData() {
        view?.showLoading()
        getAddressesFromStorage()
        updateViewWithData()
    }

    // Получаем данные об адресе из хранилища и обновляем таблицу
    func getAddressesFromStorage() {
        addresses = storageService.getAllAddresses()
    }

    // Если какие-то данные не получили, то показывает алерт с ошибкой, если все ок, то выставляем статус success
    func updateViewWithData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self, let addresses else { self?.setErrorState(); return }
            view?.configure(with: addresses)
        }
    }

    // Когда получаем ошибку, то роутеру говорим показать алерт и вью показывает UI для ошибки
    func setErrorState() {
        router.showAddressErrorAlert()
        view?.showError()
    }
}

// MARK: - Supporting methods
private extension ChooseAddressPresenter {
    func addressCellTapped(_ addressName: String) {
        onAddressCellTapped?(addressName)
        router.dismiss()
    }

    func editAddressCellTapped(_ indexPath: IndexPath) {
        guard let address = addresses?[indexPath.row] else { print("Address not found"); return }
        onEditAddressCellTapped?(address)
    }

    func addNewAddressButtonTapped() {
        onShowAddNewAddress?()
    }
}
