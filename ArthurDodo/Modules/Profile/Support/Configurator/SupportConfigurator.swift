
final class SupportConfigurator {

    // MARK: - Methods
    func configure() -> SupportViewController {
        let router = SupportRouter()
        let presenter = SupportPresenter(router: router)
        let view = SupportViewController(output: presenter)

        presenter.view = view
        router.view = view

        return view
    }
}

