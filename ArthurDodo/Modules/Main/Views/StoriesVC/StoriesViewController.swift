import UIKit
import Combine

protocol StoriesViewProtocol: AnyObject {
    func updateStoryImage(_ imageName: String?)
    func setupProgressViews(_ countOfSubStories: Int)
    func updateProgressViewProgress(_ index: Int?, progress: Float?)
    func resetProgressView(_ index: Int)
    func fillProgressView(_ index: Int)
    func fillAllProgressViewsExceptLast()
}

final class StoriesVC: UIViewController {

    // MARK: - UI Properties
    private lazy var dismissButton = AppDismissButtonView(type: .storiesWhite)
    private lazy var storiesImageView = AppImageView(type: .stories)
    private lazy var progressViewsStack = AppStackView([], axis: .horizontal, spacing: 15, distribution: .fillEqually)
    private lazy var contentStack = AppStackView([progressViewsStack, dismissButton], axis: .horizontal, spacing: 10, alignment: .center)

    // MARK: - Other properties
    private lazy var progressViews: [UIProgressView] = []

    private let viewModel: StoriesViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init
    init(viewModel: StoriesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        dataBinding()
//        presenter.viewDidLoad()

        viewModel.initialize()
    }
}

// MARK: - StoriesViewProtocol
extension StoriesVC: StoriesViewProtocol {
    func getViewModel() -> StoriesViewModelProtocol {
        viewModel
    }

    // Метод позволяет для каждого экрана сформировать ряд одинаковых панелей (сверху) для таймера
    func setupProgressViews(_ countOfSubStories: Int) {
        clearOldProgressViews()
        configureNewProgressViewsStack(countOfSubStories)
    }

    // Устанавливает значение прогресса у бара (то есть делает движение прогресс бара)
    func updateProgressViewProgress(_ index: Int?, progress: Float?) {
        guard let progress, let index else { return }
//        print(index, progress)
        let animation = progress != 0.0 && progress != 1.0 // Если прогресс != 0 тогда делай с анимацией

        progressViews[index].setProgress(progress, animated: animation)
    }

    // Обнуляет прогресс у конкретной progressView
    func resetProgressView(_ index: Int) {
        progressViews[index].setProgress(0.0, animated: false)
    }

    // Обнуляет прогресс у конкретной progressView
    func fillProgressView(_ index: Int) {
        progressViews[index].setProgress(1.0, animated: false)
        print(#function, index)
    }

    // Устанавливаем картинку
    func updateStoryImage(_ imageName: String?) {
        guard let imageName else { print("We have no image"); return }
        storiesImageView.image = UIImage(named: imageName)
    }

    // Мгновенно закрашиваем все прогрессы кроме последнего
    func fillAllProgressViewsExceptLast() {
        for view in progressViews {
            if view != progressViews.last {
                view.setProgress(1.0, animated: false)
            }
        }
    }
}

// MARK: - Setup UI
private extension StoriesVC {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(storiesImageView, contentStack)
        setupTapGesture()
        setupConstraints()
    }

    func setupConstraints() {
        storiesImageView.setConstraints(isSafeArea: true)
        contentStack.setLocalConstraints(isSafeArea: true, top: 10, left: 10, right: 10)
    }
}

// MARK: - Setup Actions
private extension StoriesVC {
    func setupActions() {
        dismissButtonAction()
    }

    func dismissButtonAction() {
        dismissButton.onButtonTapped = { [weak self] in
            guard let self else { return }
            viewModel.dismissButtonTapped()
        }
    }
}

// MARK: - Setup progressViews
private extension StoriesVC {
    // Очищаем стек и views от старых данных
    func clearOldProgressViews() {
        progressViewsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        progressViews = []
    }

    // В зависимости от того сколько сабСторисов формируется массив из одинаковых элементов
     func configureNewProgressViewsStack(_ countOfSubStories: Int) {
        for _ in 0..<countOfSubStories {
            let progressView = AppProgressView()
            progressViewsStack.addArrangedSubview(progressView)
            progressViews.append(progressView)
        }
    }
}

// MARK: - Setup TapGesture
private extension StoriesVC {
    func setupTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(gesture)
    }

    // Отправляет в презентер точку касания экрана и границы экрана
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        viewModel.storyTapped(location, view.bounds)
    }
}

// MARK: - Data Binding
private extension StoriesVC {
    func dataBinding() {
        viewModel.progressSubStoriesIndexPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] progress, subStoryIndex in
                guard let self else { return }
                updateProgressViewProgress(subStoryIndex, progress: progress)
            }
            .store(in: &cancellables)

        viewModel.subStoriesCountPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] countOfSubStories in
                guard let self else { return }
                setupProgressViews(countOfSubStories)
            }
            .store(in: &cancellables)

        viewModel.storyImagePublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self else { return }
                updateStoryImage(image)
            }
            .store(in: &cancellables)

//        viewModel.fillProgressViewIndexPublisher
//            .compactMap { $0 }
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] index in
//                guard let self else { return }
//                fillProgressView(index)
//            }
//            .store(in: &cancellables)

        viewModel.resetProgressViewIndexPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self else { return }
                resetProgressView(index)
            }
            .store(in: &cancellables)
    }
}
