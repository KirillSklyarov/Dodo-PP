import UIKit

final class StoriesView: UIView {

    // MARK: - UI Properties
    private lazy var dismissButton = AppDismissButtonView(type: .storiesWhite)
    private lazy var storiesImageView = AppImageView(type: .stories)
    private lazy var progressViewsStack = AppStackView([], axis: .horizontal, spacing: 15, distribution: .fillEqually)
    private lazy var contentStack = AppStackView([progressViewsStack, dismissButton], axis: .horizontal, spacing: 10, alignment: .center)

    private lazy var progressViews: [UIProgressView] = []

    // MARK: - Properties
    private let padding: CGFloat = 10
    private let progressViewHeight: CGFloat = 2
    private var currentStoryIndex = 0
    private var countSubStories = 0
    private var subStoryIndex = 0

    private var stories: [Story]

    var onDismissButtonTapped: (() -> Void)?

    // MARK: - Timer properties
    private var displayLink: CADisplayLink?
    private lazy var elapsedTime: TimeInterval = 0.0
    private lazy var durationOfStory: TimeInterval = 2.0

    // MARK: - Init
    init(_ story: [Story]) {
        self.stories = story
        super.init(frame: .zero)
        setupUI()
        setupActions()
    }

    deinit {
        displayLink?.invalidate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension StoriesView {
    func showSelectedStory(_ indexPath: IndexPath) {
        currentStoryIndex = indexPath.row
        countSubStories = stories[currentStoryIndex].subStoryImages.count
        showStory()
    }

    func configure(with stories: [Story]) {
        self.stories = stories
    }
}

// MARK: - Setup actions
private extension StoriesView {
    func setupActions() {
        dismissButtonTapped()
    }

    func dismissButtonTapped() {
        dismissButton.onButtonTapped = { [weak self] in
            guard let self else { return }
            onDismissButtonTapped?()
            displayLink?.invalidate()
        }
    }
}

// MARK: - Setup Stories
private extension StoriesView {

    func showStory() {
        setupProgressViews()
        subStoryIndex = 0
        showSubStory(subStoryIndex)
    }

    // Устанавливаем таймер
    func startTimer() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateProgress))
        displayLink?.add(to: .main, forMode: .default)
    }

    func stopTimer() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc func updateProgress() {
        guard subStoryIndex < progressViews.count else { return }

        elapsedTime += displayLink?.duration ?? 0
        let progress = Float(elapsedTime / durationOfStory)
        progressViews[subStoryIndex].setProgress(progress, animated: true)

        if elapsedTime >= durationOfStory {
            displayLink?.invalidate()
            displayLink = nil
            markStoryAsViewed()
            subStoryIndex += 1
            showSubStory(subStoryIndex)
        }
    }

    func markStoryAsViewed() {
        print("currentStoryIndex \(currentStoryIndex)")
        let storyID = stories[currentStoryIndex].id
        UserDefaults.standard.markStoryAsViewed(storyID)
        let viewedStories = UserDefaults.standard.getArrayOfViewedStories()
        print(viewedStories)
    }

    func showSubStory(_ subStoryIndex: Int) {
        if subStoryIndex < countSubStories {
            setStoryImage(subStoryIndex)
            resetTimerAndProgressView(subStoryIndex)
            stopTimer()
            startTimer()
        } else {
            showNextStory()
        }
    }

    // Сбрасываем таймер и прогресс-бар
    func resetTimerAndProgressView(_ subStoryIndex: Int) {
        elapsedTime = 0.0
        progressViews[subStoryIndex].progress = 0.0
    }

    func setStoryImage(_ index: Int) {
        let storyToShow = stories[currentStoryIndex]
        guard index < storyToShow.subStoryImages.count else { return }
        let imageName = storyToShow.subStoryImages[index]
        let image = UIImage(named: imageName)
        storiesImageView.image = image
    }

    // Либо показываем предыдущую Мини-Историю, либо последнюю Мини-историю предыдущей истории, либо предыдущую историю
    func showPreviousStory() {
        if subStoryIndex != 0 {
            clearProgressView()
            subStoryIndex -= 1
            showSubStory(subStoryIndex)
        } else if currentStoryIndex != 0 {
            currentStoryIndex -= 1
            showLastSubStory()
        } else {
            showStory()
        }
    }

    // Когда мы возвращаемся на предыдущую сторис, но тут делаем чтобы мы вернулись на последнюю Мини-Историю предыдущей истории
    func showLastSubStory() {
        countSubStories = stories[currentStoryIndex].subStoryImages.count
        subStoryIndex = countSubStories - 1
        setupProgressViews()
        fillAllProgressViewsExceptLast()
        showSubStory(subStoryIndex)
    }

    // Либо показываем следующую Мини-Историю, либо следующую Историю, либо закрываем окно
    func showNextStory() {
        if subStoryIndex < countSubStories - 1 {
            fillProgressView()
            subStoryIndex += 1
            showSubStory(subStoryIndex)
        } else if currentStoryIndex != stories.count - 1 {
            currentStoryIndex += 1
            countSubStories = stories[currentStoryIndex].subStoryImages.count
            showStory()
        } else {
            onDismissButtonTapped?()
        }
    }

    // Мгновенно закрашиваем прогресс
    func fillProgressView() {
        displayLink?.invalidate()
        progressViews[subStoryIndex].setProgress(1.0, animated: false)
    }

    // Мгновенно закрашиваем все прогрессы кроме последнего
    func fillAllProgressViewsExceptLast() {
        for view in progressViews {
            if view != progressViews.last {
                displayLink?.invalidate()
                view.setProgress(1.0, animated: false)
            }
        }
    }

    // Мгновенно обнуляем прогресс вью
    func clearProgressView() {
        displayLink?.invalidate()
        progressViews[subStoryIndex].setProgress(0.0, animated: false)
    }
}

// MARK: - Setup TapGesture
private extension StoriesView {

    @objc func onTap(_ sender: UITapGestureRecognizer) {
        setupTapGesture(sender)
    }

    func setupTapGesture(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        if location.x < bounds.width / 2 {
            showPreviousStory()
        } else {
            showNextStory()
        }
    }
}

// MARK: - SetupUI
private extension StoriesView {
    func setupProgressViews() {
        progressViewsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        progressViews = []
        for _ in 0..<countSubStories {
            let progressView = AppProgressView()
            progressViewsStack.addArrangedSubview(progressView)
            progressViews.append(progressView)
        }
    }

    func setupUI() {
        backgroundColor = AppColors.buttonGray
        layer.cornerRadius = 20
        layer.masksToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(gesture)

        addSubviews(storiesImageView, contentStack)

        setupConstraints()
    }

    func setupConstraints() {
        storiesImageView.setConstraints()
        contentStack.setLocalConstraints(top: 10, left: 10, right: 10)
    }
}
