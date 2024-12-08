import UIKit

final class FeatureToggleVC: UIViewController {

    // MARK: - UI Properties
    private lazy var featuresTableView = setupFeaturesTableView()
    private lazy var startButton = AppButtons(type: .cartOrange, text: "Start App")
    private lazy var contentStackView = setupContentStack()

    // MARK: - Properties
    private var localFeatures: [Feature] = []
    private var remoteFeatures: [Feature] = []

    var onStartButtonTapped: (() -> Void)?

    private var storage: DataStorage

    // MARK: - Init
    init(storage: DataStorage) {
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
        fetchData()
    }
}

// MARK: - Fetch Data
private extension FeatureToggleVC {
    // Забираем из хранилища локальные и удаленные фичи
    func fetchData() {
        localFeatures = storage.getLocalFeatureToggles()
        remoteFeatures = storage.getRemoteFeatureToggles()
    }
}

// MARK: - Setup UI
private extension FeatureToggleVC {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(contentStackView)
        setupLayout()
    }

    func setupLayout() {
        contentStackView.setConstraints(isSafeArea: true, insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

    func setupFeaturesTableView() -> AppTableView {
        let tableView = AppTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCell(FeatureToggleTableViewCell.self)
        tableView.rowHeight = 90
        tableView.backgroundColor = .clear
        return tableView
    }

    // Настраиваем contentStack (тут два стека для того чтобы разместить не по высоте всего экрана, а сделать данные сверху)
    func setupContentStack() -> UIStackView {
        let stackView = AppStackView([featuresTableView, startButton], axis: .vertical, spacing: 40)

        let contentStackView = AppStackView([stackView], axis: .horizontal, alignment: .top)
        return contentStackView
    }
}


// MARK: - Setup actions
private extension FeatureToggleVC {
    func setupAction() {
        startButton.onButtonTapped = { [weak self] in
            guard let self else { return }
            storage.setFeaturesArray()
            onStartButtonTapped?()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FeatureToggleVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        localFeatures.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(indexPath) as FeatureToggleTableViewCell
        let localFeature = localFeatures[indexPath.row]
        let remoteFeature = remoteFeatures[indexPath.row]
        cell.configureCell(localFeature, remoteFeature)

        // Когда переключаем свитч, но в хранилище обновляем значение
        cell.onSwitchToggle = { [weak self] isOn in
            guard let self else { return }
            storage.updateLocalFeatures(indexPath, isOn)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        TableViewHeaderView()
    }
}
