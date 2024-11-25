import UIKit

final class StoriesVC: UIViewController {

    // MARK: - Properties
    private lazy var backgroundView = BackgroundStoriesView(story: story)

    private var story: [Story]

    var onDismissed: (() -> Void)?

    // MARK: - Init
    init(indexPath: IndexPath, story: [Story]) {
        self.story = story
        super.init(nibName: nil, bundle: nil)
        showStories(indexPath)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            onDismissed?()
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
