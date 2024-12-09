import Foundation

protocol AddNewAddressPresenterProtocol: AnyObject {
    func viewDidLoad()
    func passNewAddressToStorage(_ newAddress: Address)
    func saveNewAddressButtonTapped(_ newAddress: Address)

    var onDismissButtonTapped: (() -> Void)? { get set }
    var onSaveNewAddressButtonTapped: (() -> Void)? { get set }
}

final class AddNewAddressPresenter {
    weak var view: AddNewAddressViewProtocol?

    // MARK: - Properties
    private var mainAddress: Address?
    private let storage: AddressStorage

    var onDismissButtonTapped: (() -> Void)?
    var onSaveNewAddressButtonTapped: (() -> Void)?

    init(storage: AddressStorage) {
        self.storage = storage
    }

    func viewDidLoad() {
        fetchData()
    }
}

// MARK: - Fetch Data
extension AddNewAddressPresenter {
    // Запрашиваем основной адрес у хранилища и показываем его на карте
    func fetchData() {
        mainAddress = storage.getMainAddress()
        guard let mainAddress else { print("We have no address to edit"); return }
        view?.showMainAddressOnMap(mainAddress) // Показываем основной адрес на карте
        updateUIWithData() // Обновляем таблицу с данными адреса (город, дом и проч.)
    }
}

extension AddNewAddressPresenter: AddNewAddressPresenterProtocol {
    // Отправляем новый адрес в хранилище
    func passNewAddressToStorage(_ newAddress: Address) {
        storage.addAddress(newAddress)
    }

    func updateUIWithData() {
        guard let mainAddress else { print("We have no address to edit"); return }
        view?.updateUIWithData(mainAddress)
    }

    func saveNewAddressButtonTapped(_ newAddress: Address) {
        passNewAddressToStorage(newAddress)
        onSaveNewAddressButtonTapped?()
    }
}
