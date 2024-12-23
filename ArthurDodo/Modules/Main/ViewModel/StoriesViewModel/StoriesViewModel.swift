import Foundation
import Combine
import QuartzCore

protocol StoriesViewModelProtocol {
    func initialize()
    func dismissButtonTapped()
    func storyTapped(_ tapPoint: CGPoint, _ bounds: CGRect)

    var storiesPublisher: Published<[Story]?>.Publisher { get }
    var progressSubStoriesIndexPublisher: Publishers.CombineLatest<Published<Float?>.Publisher,  Published<Int?>.Publisher> { get }
    var subStoriesCountPublisher: Published<Int?>.Publisher { get }
    var storyImagePublisher: Published<String?>.Publisher { get }

    var onDismissed: (() -> Void)? { get set }


//    var progressPublisher: Published<Float?>.Publisher { get }
}

final class StoriesViewModel {
    // MARK: - Properties
//    weak var view: StoriesViewProtocol?
    @Published private var stories: [Story]? // Это полный список сторисов
    @Published private var progress: Float?
    @Published private var subStoryIndex: Int?
    @Published private var subStoriesCount: Int?

    var storiesPublisher: Published<[Story]?>.Publisher { $stories }
    var progressPublisher: Published<Float?>.Publisher { $progress }
    var subStoriesIndexPublisher: Published<Int?>.Publisher { $subStoryIndex }

    lazy var progressSubStoriesIndexPublisher = Publishers.CombineLatest(progressPublisher, subStoriesIndexPublisher)
    var subStoriesCountPublisher: Published<Int?>.Publisher { $subStoriesCount }

    private var storyIndex: Int

    @Published private var storyImageName: String?
    var storyImagePublisher: Published<String?>.Publisher { $storyImageName }

    var onDismissed: (() -> Void)?

    private let storage: MainStorage

    // MARK: - Timer properties
    private var displayLink: CADisplayLink?
    private lazy var elapsedTime: TimeInterval = 0.0
    private lazy var durationOfStory: TimeInterval = 5.0

    // MARK: - Init
    init(storage: MainStorage, indexPath: IndexPath) {
        self.storage = storage
        self.storyIndex = indexPath.row
        fetchStories()
    }

    deinit {
        stopTimer()
    }
}

// MARK: - StoriesViewModelProtocol
extension StoriesViewModel: StoriesViewModelProtocol {
    // Показываем конкретную сторис. Устанавливаем какую историю показывать (storyIndex) и определяем сколько сабСторисов есть у этой сторис, потом показываем сторис
    func initialize() {
        showStory()
    }

    // Срабатывает когда мы закрываем окно со сторисами
    func dismissButtonTapped() {
        stopTimer()
        onDismissed?()
    }

    // Отрабатываем касание на сторисах. Если было касание в левой части экрана, то показываем предыдущую сторис, если в правой части экрана - показываем следующую сторис
    func storyTapped(_ tapPoint: CGPoint, _ bounds: CGRect) {
        if tapPoint.x < bounds.width / 2 {
            storiesLeftTapped()
        } else {
            showNextSubStory()
        }
    }
}

// MARK: - Setup Timer
private extension StoriesViewModel {
    // Устанавливаем таймер
    func startTimer() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateProgress))
        displayLink?.add(to: .main, forMode: .default)
    }

    // Останавливаем таймер
    func stopTimer() {
        displayLink?.invalidate()
        displayLink = nil
    }

    // Отслеживает прогресс показа сториса
    @objc func updateProgress() {
        guard let subStoriesCount else { print("SubStoriesCount is nil"); return }
        guard let subStoryIndex else { print("SubStoryIndex is nil"); return }
        guard subStoryIndex < subStoriesCount else { print("SubStoryIndex out of range"); return }

        updateProgressView()
        isNeedToShowNewStory()
    }

    // Рассчитываем прогресс (то есть сколько прошло времени у сториса) и обновляем progressView
    func updateProgressView() {
        elapsedTime += displayLink?.duration ?? 0
        progress = Float(elapsedTime / durationOfStory)
//        view?.updateProgressViewProgress(subStoryIndex, progress: progress)
    }

    // Когда заканчивается время показа сториса, то мы должны показать новый сторис
    func isNeedToShowNewStory() {
        if elapsedTime >= durationOfStory {
            stopTimer() // Останавливает таймер
            markStoryAsViewed(storyIndex) // Отмечает сторис как просмотренную
//            showNextSubStory() // Показывает новую сабСторис
            showNextSubStoryOrNextStory()
        }
    }
}

// MARK: - Supporting methods
private extension StoriesViewModel {
    func fetchStories() {
        stories = storage.getFetchedStories()
    }

    // Обновляем кол-во сабСторисов, обновляем UI, показываем первый сабСторис этой сторис
    func showStory() {
        updateSubStoriesCount()
//        updateUI()
//        showNextSubStoryOrNextStory()

        setStoryImage()
        startTimer()
    }

    // Мы обновляем кол-во сабСторисов (нужно делать каждый раз когда у нас переключаются сторисы)
    func updateSubStoriesCount() {
        guard let stories else { print("Stories are not fetched yet"); return }
        subStoriesCount = stories[storyIndex].subStories.count
        subStoryIndex = 0
    }

    // Если можно показать новую сабСторис (индекс сабСториса меньше кол-ва сабСторисов), то показываем следующую сабсторис, если нет - то показываем новую историю.
    func showNextSubStoryOrNextStory() {
        guard let subStoriesCount else { print("SubStoriesCount is nil"); return }
        guard let subStoryIndex else { print("SubStoryIndex is nil"); return }

        if (subStoryIndex + 1) < subStoriesCount {
            showNextSubStory()
//            showSubStory()
        } else {
            showNextStoryOrDismiss()
        }
    }

    // Cбрасываем таймер и прогресс, показываем картинку и начинаем таймер
    func showSubStory() {
        resetTimerAndProgressView()
        setStoryImage()
        startTimer()
    }

    func showSubStoryTest() {
        resetTimerAndProgressView()
        setStoryImage()
        startTimer()
    }

    // Если сторис последняя, то закрываем окно, если нет - показываем следующую сторис
    func showNextStoryOrDismiss() {
        guard let stories else { print("Stories are not fetched yet"); return }
        let isStoryLast = storyIndex == stories.count - 1
        isStoryLast ? dismissButtonTapped() : showNextStory()
    }

    // Показывает новую сторис: увеличиваем счетчик сторисов на 1, обновляем кол-во сабСторисов и показываем сторис
    func showNextStory() {
        print(#function)
        storyIndex += 1
//        updateSubStoriesCount()
        resetTimerAndProgressView()
        showStory()
    }

    // Сбрасываем таймер и прогресс-бар
    func resetTimerAndProgressView() {
        stopTimer()
        elapsedTime = 0.0
        progress = 0.0
        //        view?.resetProgressView(subStoryIndex)
    }

    // Показываем последнюю сабСторис предыдущей сторис
     func showLastSubStoryPreviousStory() {
        storyIndex -= 1
        showLastSubStory()
    }

    // Показывает предыдущую сабСторис
     func showPreviousSubStory() {
        resetProgressView()
        subStoryIndex! -= 1
        showNextSubStoryOrNextStory()
    }

    // Либо показываем предыдущую Мини-Историю, либо последнюю Мини-историю предыдущей истории, либо предыдущую историю
    func storiesLeftTapped() {
        if subStoryIndex != 0 {
            showPreviousSubStory()
        } else if storyIndex != 0 {
            showLastSubStoryPreviousStory()
        } else {
            showStory()
        }
    }

    // Когда мы возвращаемся на предыдущую сторис, но тут делаем чтобы мы вернулись на последнюю Мини-Историю предыдущей истории
    func showLastSubStory() {
        guard let subStoriesCount else { print("SubStoriesCount is nil"); return }
        updateSubStoriesCount() // Обновляем кол-во сабСторисов
        subStoryIndex = subStoriesCount - 1
        updateUIWithFilledProgressViews() // Отрисовываем правильные progress views и закрашиваем все, кроме последнего
        showNextSubStoryOrNextStory()
    }

    // Обновляем UI: устанавливаем правильный прогресс бар, то есть кол-во отрезков по кол-ву сабСторисов
    func updateUI() {
//        view?.setupProgressViews(subStoriesCount)
    }

    // Отрисовываем правильные Progress Views и закрашиваем все, кроме последнего (нужно когда мы показываем последнюю сабСторис при переключении назад)
    func updateUIWithFilledProgressViews() {
        updateUI()
//        view?.fillAllProgressViewsExceptLast()
    }

    // Отмечаем историю как просмотренную
    func markStoryAsViewed(_ index: Int) {
        guard let stories else { print("Stories are not fetched yet"); return }
        let storyID = stories[index].id
        UserDefaults.standard.markStoryAsViewed(storyID)
    }

    // Мы принимаем индекс сториса и индекс сабСториса и устанавливаем картинку сториса
    func setStoryImage() {
        print(#function)
        guard let stories else { print("Stories are not fetched yet"); return }
        guard let subStoryIndex else { print("SubStoryIndex is nil"); return }

        let storyToShow = stories[storyIndex]
        guard subStoryIndex < storyToShow.subStories.count else { print("Oooops"); return }
        storyImageName = storyToShow.subStories[subStoryIndex]
        print("storyImageName \(storyImageName)")
//        view?.updateStoryImage(imageName)
    }

    // Сначала закрашиваем progressView у предыдущей сабСторис и показываем следующий сабСторис
    func showNextSubStory() {
//        print(#function)
//        fillProgressView()
        subStoryIndex! += 1
        showSubStory()
//        showNextSubStoryOrNextStory()
    }

    // Мгновенно закрашиваем прогресс
    func fillProgressView() {
        progress = 1.0
//        view?.fillProgressView(subStoryIndex)
    }

    // Мгновенно обнуляем прогресс вью
    func resetProgressView() {
        progress = 0
//        view?.resetProgressView(subStoryIndex)
    }
}
