import UIKit

protocol StoriesViewControllerInput: BaseViewControllerInput where inputData == Int {
    func setupProgressViews(_ countOfSubStories: Int)
    func updateStoryImage(_ imageName: String?)
    func updateProgressViewProgress(_ index: Int?, progress: Float?)
    func fillAllProgressViewsExceptLast()
}

final class StoriesViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var dismissButton = AppDismissButtonView(type: .storiesWhite)
    private lazy var storiesImageView = AppImageView(type: .stories)
    private lazy var progressViewsStack = AppStackView([], axis: .horizontal, spacing: 15, distribution: .fillEqually)
    private lazy var contentStack = AppStackView([progressViewsStack, dismissButton], axis: .horizontal, spacing: 10, alignment: .center)

    private lazy var activityIndicator = AppActivityIndicator()

    // MARK: - Other properties
    private lazy var progressViews: [UIProgressView] = []

    let output: any StoriesViewControllerOutput

    // MARK: - Init
    init(output: any StoriesViewControllerOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewLoaded()
    }
}

// MARK: - StoriesViewControllerInput
extension StoriesViewController: StoriesViewControllerInput {
    func setupInitialState() {
        setupUI()
        setupActions()
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
        isShowContent(false)
    }

    func configure(with data: Int) {
        activityIndicator.stopAnimating()
        isShowContent(true)
        setupProgressViews(data)
    }

    func showError() {
        activityIndicator.stopAnimating()
    }

    // Метод позволяет для каждого экрана сформировать ряд одинаковых панелей (сверху) для таймера
    func setupProgressViews(_ countOfSubStories: Int) {
        isShowContent(true)
        clearOldProgressViews()
        configureNewProgressViewsStack(countOfSubStories)
    }

    // Устанавливаем картинку
    func updateStoryImage(_ imageName: String?) {
        guard let imageName else { print("We have no image"); return }
        storiesImageView.image = UIImage(named: imageName)
    }

    // Устанавливает значение прогресса у бара (то есть делает движение прогресс бара)
    func updateProgressViewProgress(_ index: Int?, progress: Float?) {
        guard let progress, let index else { return }

        // Если прогресс != 0, 1 тогда делай с анимацией (то есть когда нужно обнулить или полностью зарисовать прогресс - это нужно делать без анимации)
        let animation =
                switch progress {
                case 0.0, 1.0: false
                default : true
                }

        progressViews[index].setProgress(progress, animated: animation)
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

// MARK: - Supporting methods
extension StoriesViewController {
    // Показываем или скрываем контент
    func isShowContent(_ show: Bool) {
        let uiComponents = [storiesImageView, contentStack]
        uiComponents.forEach { $0.alpha = show ? 1 : 0 }
    }
}

// MARK: - Setup UI
private extension StoriesViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(storiesImageView, contentStack, activityIndicator)
        setupTapGesture()
        setupConstraints()
    }

    func setupConstraints() {
        storiesImageView.setConstraints(isSafeArea: true)
        contentStack.setLocalConstraints(isSafeArea: true, top: 10, left: 10, right: 10)

        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

// MARK: - Setup Actions
private extension StoriesViewController {
    func setupActions() {
        dismissButtonAction()
    }

    func dismissButtonAction() {
        dismissButton.onButtonTapped = { [weak self] in
            guard let self else { return }
            output.sendAction(.dismissButtonTapped)
        }
    }
}

// MARK: - Setup progressViews
private extension StoriesViewController {
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
private extension StoriesViewController {
    // Устанавливаем жест (тап слева предыдущая сторис, тап справа - следующая)
    func setupTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(gesture)
    }

    // Отправляет в презентер точку касания экрана и границы экрана
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        output.sendAction(.storyTapped(location, view.bounds))
    }

    func updateUI(countOfSubStories: Int, storyImage: String) {
        print(#function)
        setupProgressViews(countOfSubStories)
        updateStoryImage(storyImage)
    }
}
