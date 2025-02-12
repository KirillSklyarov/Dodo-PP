
final class SupportConfigurator {

    // MARK: - Methods
    func configure() -> SupportViewController {
        let presenter = SupportPresenter()
        let view = SupportViewController(output: presenter)

        presenter.view = view

        return view
    }
}

