import Foundation

final class FeatureToggleStorage {

    // Feature Toggles
    private var localFeatures: [Feature] = []
    private var remoteFeatures: [Feature] = []
    private var features: [FeatureType: Bool] = [:]

    var onLocalFeaturesChanged: (() -> Void)?
}

// MARK: - Feature toggles
extension FeatureToggleStorage {
    func getLocalFeatureToggles() -> [Feature] {
        localFeatures
    }

    func getRemoteFeatureToggles() -> [Feature] {
        remoteFeatures
    }

    func setLocalFeatureToggles(_ features: [Feature]) {
        self.localFeatures = features.sorted(by: { $0.name < $1.name })
    }

    func setRemoteFeatureToggles(_ features: [Feature]) {
        self.remoteFeatures = features.sorted(by: { $0.name < $1.name })
    }

    func updateLocalFeatures(_ indexPath: IndexPath, _ status: Bool) {
        localFeatures[indexPath.row].isEnabled = status
        onLocalFeaturesChanged?()
    }

    //  Формируем итоговый словарь, где значение enable будет только в том случае, если у обоих массивов будет значение true
    func setFeaturesArray() {
        let localDict = Dictionary(uniqueKeysWithValues: localFeatures.map { ($0.name, $0.isEnabled) } )
        let remoteDict = Dictionary(uniqueKeysWithValues: remoteFeatures.map { ($0.name, $0.isEnabled) } )

        var appDict: [FeatureType: Bool] = [:]

        for (key, value) in localDict {
            let remoteValue = remoteDict[key]
            let isTrue = (value == true && remoteValue == true)

            if let newKey = FeatureType(rawValue: key) {
                appDict[newKey] = isTrue
            }
        }

        self.features = appDict
        print("features \(features)")
    }

    // Отдаем правильные словарь фичей
    func getFeatures() -> [FeatureType: Bool] {
        features
    }
}
