import Foundation

final class FeatureToggleService {

    // MARK: - Properties
    private var localFeatures: [Feature] = []
    private var remoteFeatures: [Feature] = []

    // MARK: - Properties
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let session: URLSession

    private let networkService: NetworkService
    private let storage: FeatureToggleStorage

    // MARK: - Init
    init(networkService: NetworkService, storage: FeatureToggleStorage, decoder: JSONDecoder, encoder: JSONEncoder, session: URLSession) {
        self.networkService = networkService
        self.storage = storage
        self.decoder = decoder
        self.encoder = encoder
        self.session = session
        setupAction()
    }

    deinit {
        print("FeatureToggleService deinit")
    }
}

// MARK: - Public methods
extension FeatureToggleService {
    // Получаем все фичи (и локальные и удаленные)
    func fetchAllFeatures() async {
        fetchLocalFeatureToggles()
        await fetchRemoteFeatureToggles()
    }

    // Возвращаем локальные фичи
    func getLocalFeaturesStoreArray() -> [Feature] {
        localFeatures
    }

    // Возвращаем удаленные фичи
    func getRemoteFeaturesStoreArray() -> [Feature] {
        remoteFeatures
    }

    // Проверяем включена ли фича
    func isFeatureEnabled(featureType: FeatureType) -> Bool {
        storage.getFeatures()[featureType] ?? false
    }

    private func setupAction() {
        storage.onLocalFeaturesChanged = { [weak self] in
            guard let self else { return }
            updateLocalFeatureToggles()
        }
    }
}

// MARK: - Fetch local features
private extension FeatureToggleService {
    // Забираем локальные фичи из локального файла и размещаем их в словаре featuresStore
    func fetchLocalFeatureToggles() {
        if let path = Bundle.main.path(forResource: "localFeatureToggles", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                let features = try decoder.decode([Feature].self, from: data)
                storage.setLocalFeatureToggles(features)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    // обновить локальный файл
    func updateLocalFeatureToggles() {
        let features = storage.getLocalFeatureToggles()

        do {
            let data = try encoder.encode(features)
            if let path = Bundle.main.path(forResource: "localFeatureToggles", ofType: "json") {
                let url = URL(fileURLWithPath: path)
                try data.write(to: url)
                print("Data saved successfully")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Fetch remote features
private extension FeatureToggleService {
    // Забираем локальные фичи из локального файла и размещаем их в словаре featuresStore
    func fetchRemoteFeatureToggles() async {
        do {
            let remoteFeaturesStoreArray = try await networkService.fetchFeatures()
            storage.setRemoteFeatureToggles(remoteFeaturesStoreArray)
        } catch {
            print(error)
        }
    }
}
