import UIKit

final class StoriesVC: UIViewController {

    // MARK: - Properties
    private lazy var backgroundView = BackgroundStoriesView()

    var onStoriesVCDismissed: (() -> Void)?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    // MARK: - Public methods
    func showStories(_ indexPath: IndexPath) {
        backgroundView.showSelectedStory(indexPath)
    }
}

// MARK: - Setup Actions
private extension StoriesVC {
     func setupActions() {
        backgroundView.onDismissButtonTapped = { [weak self] in
            guard let self else { return }
            onStoriesVCDismissed?()
            dismiss(animated: true)
        }
    }
}

// MARK: - Setup UI
private extension StoriesVC {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack

        view.addSubviews(backgroundView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
