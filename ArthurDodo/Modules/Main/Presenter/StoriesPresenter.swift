//import Foundation
////import QuartzCore
////
//protocol StoriesPresenterProtocol: AnyObject {
//    func viewDidLoad()
//    func dismissButtonTapped()
//    func storyTapped(_ tapPoint: CGPoint, _ bounds: CGRect)
//
//    var onDismissed: (() -> Void)? { get set }
//}
////
////// Презентер экрана сторисов
//final class StoriesPresenter {
//
//    // MARK: - Properties
//    weak var view: StoriesViewProtocol?
//    private let storage: MainStorage
//    private var stories: [Story] = [] // Это полный список сторисов
//
//    var onDismissed: (() -> Void)?
//
//    private var storyIndex: Int
//    private var subStoriesCount = 0
//    private var subStoryIndex = 0
//
//    // MARK: - Timer properties
//    private var displayLink: CADisplayLink?
//    private lazy var elapsedTime: TimeInterval = 0.0
//    private lazy var durationOfStory: TimeInterval = 2.0
//
//    // MARK: - Init
//    init(storage: MainStorage, indexPath: IndexPath) {
//        self.storage = storage
//        self.storyIndex = indexPath.row
//        fetchStories()
//    }
//
//    deinit {
//        stopTimer()
//    }
//}
//
//// MARK: - StoriesPresenterProtocol
//extension StoriesPresenter: StoriesPresenterProtocol {
//    // Показываем конкретную сторис. Устанавливаем какую историю показывать (storyIndex) и определяем сколько сабСторисов есть у этой сторис, потом показываем сторис
//    func viewDidLoad() {
//        showStory()
//    }
//
//    // Срабатывает когда мы закрываем окно со сторисами
//    func dismissButtonTapped() {
//        stopTimer()
//        onDismissed?()
//    }
//
//    // Отрабатываем касание на сторисах. Если было касание в левой части экрана, то показываем предыдущую сторис, если в правой части экрана - показываем следующую сторис
//    func storyTapped(_ tapPoint: CGPoint, _ bounds: CGRect) {
//        if tapPoint.x < bounds.width / 2 {
//            storiesLeftTapped()
//        } else {
//            showNextSubStory()
//        }
//    }
//}
//
//// MARK: - Setup Timer
//private extension StoriesPresenter {
//    // Устанавливаем таймер
//    func startTimer() {
//        displayLink = CADisplayLink(target: self, selector: #selector(updateProgress))
//        displayLink?.add(to: .main, forMode: .default)
//    }
//
//    // Останавливаем таймер
//    func stopTimer() {
//        displayLink?.invalidate()
//        displayLink = nil
//    }
//
//    // Отслеживает прогресс показа сториса
//    @objc func updateProgress() {
//        guard subStoryIndex < subStoriesCount else { print("SubStoryIndex out of range"); return }
//        updateProgressView()
//        isNeedToShowNewStory()
//    }
//
//    // Рассчитываем прогресс (то есть сколько прошло времени у сториса) и обновляем progressView
//    func updateProgressView() {
//        elapsedTime += displayLink?.duration ?? 0
//        let progress = Float(elapsedTime / durationOfStory)
//        view?.updateProgressViewProgress(subStoryIndex, progress: progress)
//    }
//
//    // Когда заканчивается время показа сториса, то мы должны показать новый сторис
//    func isNeedToShowNewStory() {
//        if elapsedTime >= durationOfStory {
//            stopTimer() // Останавливает таймер
//            markStoryAsViewed(storyIndex) // Отмечает сторис как просмотренную
//            showNextSubStory() // Показывает новую сабСторис
//        }
//    }
//}
//
//// MARK: - Supporting methods
//private extension StoriesPresenter {
//    // Обновляем кол-во сабСторисов, обновляем UI, показываем первый сабСторис этой сторис
//    func showStory() {
//        updateSubStoriesCount()
//        updateUI()
//        showNextSubStoryOrNextStory()
//    }
//
//    // Если можно показать новую сабСторис (индекс сабСториса меньше кол-ва сабСторисов), то показываем следующую сабсторис, если нет - то показываем новую историю.
//    func showNextSubStoryOrNextStory() {
//        if subStoryIndex < subStoriesCount {
//            showSubStory()
//        } else {
//            showNextStoryOrDismiss()
//        }
//    }
//
//    // Cбрасываем таймер и прогресс, показываем картинку и начинаем таймер
//    func showSubStory() {
//        resetTimerAndProgressView()
//        setStoryImage()
//        startTimer()
//    }
//
//    // Если сторис последняя, то закрываем окно, если нет - показываем следующую сторис
//    func showNextStoryOrDismiss() {
//        let isStoryLast = storyIndex == stories.count - 1
//        isStoryLast ? dismissButtonTapped() : showNextStory()
//    }
//
//    // Показывает новую сторис: увеличиваем счетчик сторисов на 1, обновляем кол-во сабСторисов и показываем сторис
//    func showNextStory() {
//        storyIndex += 1
//        updateSubStoriesCount()
//        showStory()
//    }
//
//    func fetchStories() {
//        stories = storage.getFetchedStories()
//    }
//
//    // Сбрасываем таймер и прогресс-бар
//     func resetTimerAndProgressView() {
//        stopTimer()
//        elapsedTime = 0.0
//        view?.resetProgressView(subStoryIndex)
//    }
//
//    // Показываем последнюю сабСторис предыдущей сторис
//     func showLastSubStoryPreviousStory() {
//        storyIndex -= 1
//        showLastSubStory()
//    }
//
//    // Показывает предыдущую сабСторис
//     func showPreviousSubStory() {
//        resetProgressView()
//        subStoryIndex -= 1
//        showNextSubStoryOrNextStory()
//    }
//
//    // Либо показываем предыдущую Мини-Историю, либо последнюю Мини-историю предыдущей истории, либо предыдущую историю
//    func storiesLeftTapped() {
//        if subStoryIndex != 0 {
//            showPreviousSubStory()
//        } else if storyIndex != 0 {
//            showLastSubStoryPreviousStory()
//        } else {
//            showStory()
//        }
//    }
//
//    // Когда мы возвращаемся на предыдущую сторис, но тут делаем чтобы мы вернулись на последнюю Мини-Историю предыдущей истории
//     func showLastSubStory() {
//        updateSubStoriesCount() // Обновляем кол-во сабСторисов
//        subStoryIndex = subStoriesCount - 1
//        updateUIWithFilledProgressViews() // Отрисовываем правильные progress views и закрашиваем все, кроме последнего
//        showNextSubStoryOrNextStory()
//    }
//
//    // Мы обновляем кол-во сабСторисов (нужно делать каждый раз когда у нас переключаются сторисы)
//    func updateSubStoriesCount() {
//        subStoriesCount = stories[storyIndex].subStories.count
//        subStoryIndex = 0
//    }
//
//    // Обновляем UI: устанавливаем правильный прогресс бар, то есть кол-во отрезков по кол-ву сабСторисов
//    func updateUI() {
//        view?.setupProgressViews(subStoriesCount)
//    }
//
//    // Отрисовываем правильные Progress Views и закрашиваем все, кроме последнего (нужно когда мы показываем последнюю сабСторис при переключении назад)
//    func updateUIWithFilledProgressViews() {
//        updateUI()
//        view?.fillAllProgressViewsExceptLast()
//    }
//
//    // Отмечаем историю как просмотренную
//    func markStoryAsViewed(_ index: Int) {
//        let storyID = stories[index].id
//        UserDefaults.standard.markStoryAsViewed(storyID)
//    }
//
//    // Мы принимаем индекс сториса и индекс сабСториса и устанавливаем картинку сториса
//    func setStoryImage() {
//        let storyToShow = stories[storyIndex]
//        guard subStoryIndex < storyToShow.subStories.count else { return }
//        let imageName = storyToShow.subStories[subStoryIndex]
//        view?.updateStoryImage(imageName)
//    }
//
//    // Сначала закрашиваем progressView у предыдущей сабСторис и показываем следующий сабСторис
//    func showNextSubStory() {
//        fillProgressView()
//        subStoryIndex += 1
//        showNextSubStoryOrNextStory()
//    }
//
//    // Мгновенно закрашиваем прогресс
//    func fillProgressView() {
//        view?.fillProgressView(subStoryIndex)
//    }
//
//    // Мгновенно обнуляем прогресс вью
//    func resetProgressView() {
//        view?.resetProgressView(subStoryIndex)
//    }
//}
