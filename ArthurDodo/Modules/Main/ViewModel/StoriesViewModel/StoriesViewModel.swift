import Foundation
import Combine
import QuartzCore

protocol StoriesViewModelProtocol: BaseViewControllerOutputOLD where ActionType == StoriesViewModelAction {

    var subStoriesCountPublisher: Published<Int?>.Publisher { get }
    var progressSubStoriesIndexPublisher: Publishers.CombineLatest<Published<Float?>.Publisher,  Published<Int?>.Publisher> { get }
    var storyImagePublisher: Published<String?>.Publisher { get }
    var fillProgressViewIndexPublisher: Published<Bool?>.Publisher { get }

    var onDismissed: (() -> Void)? { get set }
}

enum StoriesViewModelAction {
    case dismissButtonTapped
    case storyTapped(CGPoint, CGRect)
}

final class StoriesViewModel {
    // MARK: - Published properties
    @Published private var progress: Float?
    @Published private var subStoryIndex: Int?
    @Published private var subStoriesCount: Int?
    @Published private var fillProgressViews: Bool?
    @Published private var storyImageName: String?

    var subStoriesCountPublisher: Published<Int?>.Publisher { $subStoriesCount }
    lazy var progressSubStoriesIndexPublisher = Publishers.CombineLatest(progressPublisher, subStoriesIndexPublisher)
    var fillProgressViewIndexPublisher: Published<Bool?>.Publisher { $fillProgressViews }
    var storyImagePublisher: Published<String?>.Publisher { $storyImageName }
    private var subStoriesIndexPublisher: Published<Int?>.Publisher { $subStoryIndex }
    private var progressPublisher: Published<Float?>.Publisher { $progress }

    // MARK: - Other properties
    private var stories: [Story]? // Это полный список сторисов
    private var storyIndex: Int

    var onDismissed: (() -> Void)?

    private let storage: MainStorage

    // MARK: - Timer properties
    private var displayLink: CADisplayLink?
    private lazy var elapsedTime: TimeInterval = 0.0
    private lazy var durationOfStory: TimeInterval = 2.0

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
    func loadData() {
        showStory()
    }

    func sendAction(_ action: StoriesViewModelAction) {
        switch action {
        case .dismissButtonTapped: dismissButtonTapped()
        case .storyTapped(let tapPoint, let bounds): storyTapped(tapPoint, bounds)
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
        updateProgressView()
        isNeedToShowNewStory()
    }

    // Рассчитываем прогресс (то есть сколько прошло времени у сториса) и обновляем progressView
    func updateProgressView() {
        elapsedTime += displayLink?.duration ?? 0
        progress = Float(elapsedTime / durationOfStory)
    }

    // Когда заканчивается время показа сториса, то мы должны показать новый сторис
    func isNeedToShowNewStory() {
        if elapsedTime >= durationOfStory {
            stopTimer() // Останавливает таймер
            markStoryAsViewed() // Отмечает сторис как просмотренную
            showNextSubStoryOrNextStory() // Показываем новый сабСторис или новый Сторис
        }
    }
}

// MARK: - Supporting methods
private extension StoriesViewModel {
    func fetchStories() {
        stories = storage.getFetchedStories()
    }

    // Обновляем кол-во сабСторисов, показываем первый сабСторис этой сторис
    func showStory() {
        updateSubStoriesCount() // Обновляем кол-во сабСторисов конкретной Сторис и начинаем с первой сабСторис
        showSubStory()
    }

    // Мы обновляем кол-во сабСторисов (нужно делать каждый раз когда у нас переключаются сторисы)
    func updateSubStoriesCount() {
        guard let stories else { print("Stories are not fetched yet"); return }
        subStoriesCount = stories[storyIndex].subStories.count
        subStoryIndex = 0
    }

    // Cбрасываем таймер и прогресс, показываем картинку и начинаем таймер
    func showSubStory() {
        resetTimerAndProgress() // Сбрасываем таймер и прогресс
        setStoryImage() // Устанавливаем картинку сториса
        startTimer() // Запускаем таймер
    }

    // Если можно показать новую сабСторис (индекс сабСториса меньше кол-ва сабСторисов), то показываем следующую сабсторис, если нет - то показываем новую историю.
    func showNextSubStoryOrNextStory() {
        guard let subStoriesCount else { print("SubStoriesCount is nil"); return }

        // Является ли текущая сабСтори последней в этой Сторис
        let isCurrentSubStoryLast = subStoryIndex == (subStoriesCount - 1)

        // Если последняя, то покажи следующую Сторис, если нет - следующую сабСторис
        isCurrentSubStoryLast ? showNextStoryOrDismiss() : showNextSubStory()
    }

    // Сначала закрашиваем progressView у предыдущей сабСторис и показываем следующий сабСторис
    func showNextSubStory() {
        stopTimer() // Останавливаем таймер
        fillProgressView() // Закрашиваем бар у предыдущей сабСторис (без этого подглючивает прогресс бар)
        increaseSubStoryIndex() // Увеличиваем счетчик сабСторис
        showSubStory() // Показываем сабСторис
    }

    // Безопасно увеличиваем счетчик сабСторис
    func increaseSubStoryIndex() {
        if var subStoryIndex {
            subStoryIndex += 1 // Увеличиваем счетчик сабСторис
            self.subStoryIndex = subStoryIndex
        }
    }

    // Если сторис последняя, то закрываем окно, если нет - показываем следующую сторис
    func showNextStoryOrDismiss() {
        guard let stories else { print("Stories are not fetched yet"); return }
        let isStoryLast = storyIndex == stories.count - 1
        isStoryLast ? dismissButtonTapped() : showNextStory()
    }

    // Показывает новую сторис: увеличиваем счетчик сторисов на 1, обновляем кол-во сабСторисов и показываем сторис
    func showNextStory() {
        stopTimer() // Останавливаем таймер
        fillProgressView() // Закрашиваем бар у предыдущей сабСторис (без этого подглючивает прогресс бар)
        resetTimerAndProgress() // Сбрасываем прогресс
        storyIndex += 1 // Увеличиваем счетчик сторисов
        showStory()
    }

    // Сбрасываем таймер и прогресс-бар
    func resetTimerAndProgress() {
        elapsedTime = 0.0 // Сбрасываем таймер
        progress = 0.0 // Сбрасываем прогресс
    }

    // Либо показываем предыдущую Мини-Историю, либо последнюю Мини-историю предыдущей истории, либо предыдущую историю
    func storiesLeftTapped() {
        if subStoryIndex != 0 {
            showPreviousSubStory() // Вызывается когда нужно показать предыдущий сабСторис текущего сториса
        } else if storyIndex != 0 {
            showLastSubStoryPreviousStory()
        } else {
            showFirstStoryAgain() // Вызывается когда при показе первой сабСтори первой сторис нажали влево
        }
    }

    // Показывает предыдущую сабСторис текущего сториса
    func showPreviousSubStory() {
        stopTimer() // Останавливаем таймер
        resetTimerAndProgress() // Сбрасываем таймер и прогресс (так обнуляется бар)
        if var subStoryIndex {
            subStoryIndex -= 1 // Уменьшаем счетчик сабСторисов
            self.subStoryIndex = subStoryIndex
            showSubStory() // Показываем сторис
        }
    }

    // Показываем последнюю сабСторис предыдущей сторис
    func showLastSubStoryPreviousStory() {
        stopTimer() // Останавливаем таймер
        resetTimerAndProgress() // Сбрасываем таймер и прогресс (так обнуляется бар)
        storyIndex -= 1 // Устанавливаем предыдущую сторис
        updateDataForTheLastSubStory() // Устанавливаем последнюю сабСторис (а не первую как в стандартном методе)
        fillAllProgressViewsExceptLast() // Заполняем все прогрессы, кроме последнего
        showSubStory() // Показываем установленную сабСторис
    }

    // Устанавливаем последнюю сабСторис (а не первую как в стандартном методе)
    func updateDataForTheLastSubStory() {
        subStoriesCount = stories?[storyIndex].subStories.count
        guard let subStoriesCount else { print("SubStoriesCount is nil"); return }
        subStoryIndex = subStoriesCount - 1
    }

    // Заполняем все прогрессы, кроме последнего
    func fillAllProgressViewsExceptLast() {
        fillProgressViews = true
    }

    // Показываем первую сторис заново
    func showFirstStoryAgain() {
        stopTimer() // Останавливаем таймер
        resetTimerAndProgress() // Сбрасываем таймер и прогресс (так обнуляется бар)
        showStory() // Показываем эту же историю заново
    }

    // Мы принимаем индекс сториса и индекс сабСториса и устанавливаем картинку сториса
    func setStoryImage() {
        guard let stories else { print("Stories are not fetched yet"); return }
        guard let subStoryIndex else { print("SubStoryIndex is nil"); return }
        guard let subStoriesCount else { print("SubStoriesCount is nil"); return }

        if subStoryIndex < subStoriesCount {
            let storyToShow = stories[storyIndex]
            storyImageName = storyToShow.subStories[subStoryIndex]
        }
    }

    // Мгновенно закрашиваем прогресс по индексу (subStoryIndex) и потом сразу сбрасываем индекс
    func fillProgressView() {
        progress = 1.0
    }

    // Отмечаем историю как просмотренную (только в том случае, если просмотрены все сабСторисы)
    func markStoryAsViewed() {
        guard let stories else { print("Stories are not fetched yet"); return }
        guard let subStoriesCount else { print("SubStoriesCount is nil"); return }

        if subStoryIndex == subStoriesCount - 1 {
            let storyID = stories[storyIndex].id
            UserDefaults.standard.markStoryAsViewed(storyID)
        }
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
            showNextSubStoryOrNextStory()
        }
    }
}
