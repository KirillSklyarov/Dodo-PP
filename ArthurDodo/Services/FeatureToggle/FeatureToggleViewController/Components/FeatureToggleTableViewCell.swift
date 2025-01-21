import UIKit
import AppUIComponentsSPM

final class FeatureToggleTableViewCell: UITableViewCell {

    // MARK: - UI Properties
    private lazy var featureLabel = AppLabel(type: .smallHeader, alignment: .center, numberOfLines: 0)
    private lazy var localFeatureSwitch = AppSwitch(isHidden: false)
    private lazy var remoteFeatureSwitch = AppSwitch(isHidden: false)
    private lazy var contentStack = setupConfigureContentStack()

    var onSwitchToggle: ((Bool) -> Void)?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configureCell(_ localFeature: Feature, _ remoteFeature: Feature) {
        featureLabel.text = localFeature.name
        localFeatureSwitch.isOn = localFeature.isEnabled
        remoteFeatureSwitch.isOn = remoteFeature.isEnabled
    }
}

// MARK: - Setup UI
private extension FeatureToggleTableViewCell {
    func setupUI() {
        setupUIElements()

        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubviews(contentStack)

        setupLayout()
    }

    func setupUIElements() {
        remoteFeatureSwitch.isUserInteractionEnabled = false
    }

    func setupLayout() {
        contentStack.setConstraints()
    }

    func setupConfigureContentStack() -> UIStackView {
        let localContainerView = setupSwitchContainerView(localFeatureSwitch)
        let remoteContainerView = setupSwitchContainerView(remoteFeatureSwitch)

        let contentStack = AppStackView([featureLabel, localContainerView, remoteContainerView], axis: .horizontal, alignment: .center, distribution: .fillEqually)
        return contentStack
    }

    // Метод размещает свитчи по центру путем создания контейнера
    private func setupSwitchContainerView(_ featureSwitch: UISwitch) -> UIView {
        let view = UIView()
        view.addSubviews(featureSwitch)

        featureSwitch.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        featureSwitch.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        featureSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        return view
    }
}

// MARK: - Setup Actions
private extension FeatureToggleTableViewCell {
    func setupActions() {
        setupSwitchAction()
    }

    func setupSwitchAction() {
        localFeatureSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        remoteFeatureSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }

    @objc func switchValueChanged(_ sender: UISwitch) {
        onSwitchToggle?(sender.isOn)
    }
}
