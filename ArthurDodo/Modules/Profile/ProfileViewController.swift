import UIKit
//import SkeletonView

final class ProfileViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = ProfileHeaderView()
    private lazy var coinsOrdersCollectionView = CoinsOrdersCollectionView(personalData: personalData)
    private lazy var promoStackView = PromoStackView()
    private lazy var missionStackView = MissionStackView()
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [coinsOrdersCollectionView, promoStackView, missionStackView])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    private lazy var scrollView = UIScrollView()

    // MARK: - Other Properties
    private let topInset: CGFloat = 10
    private var personalData: Personal?

    private let storage = DataStorage.shared
    private lazy var router = Router(baseVC: self)

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        fetchData()
    }
}

// MARK: - Fetch Data
private extension ProfileViewController {
    func fetchData() {
        fetchPromo()
        fetchPersonalData()
    }

    func fetchPromo() {
        storage.fetchPromo()
        storage.onPromoFetchedSuccessfully = { [weak self] promo in
            DispatchQueue.main.async {
                self?.promoStackView.updateUI(promo)
            }
        }
    }

    func fetchPersonalData() {
        print("Here")
        coinsOrdersCollectionView.collectionShowSkeleton()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            storage.fetchPersonalData()
            storage.onPersonalDataFetchedSuccessfully = { [weak self] personalData in
                self?.coinsOrdersCollectionView.stopShowingSkeleton()
                self?.personalData = personalData
                self?.coinsOrdersCollectionView.updateUI(personalData)

            }
        }

    }
}

// MARK: - Setup Actions
private extension ProfileViewController {
    func setupActions() {
        setupHeaderViewActions()
        setupSpecialOfferActions()
    }

    func setupHeaderViewActions() {
        headerView.onDismissButtonTapped = { [weak self] in
            self?.dismiss(animated: true)
        }

        headerView.onChatButtonTapped = { [weak self] in
            self?.showChatAlert()
        }

        headerView.onProfileButtonTapped = { [weak self] in
            self?.showPersonalVC()
        }
    }

    func showChatAlert() {
        router.navigate(to: .supportAlert, animated: false)
    }

    func showPersonalVC() {
        router.navigate(to: .personalData)
    }

    func setupSpecialOfferActions() {
        promoStackView.onPromoSelected = { [weak self] specialOffer in
            guard let self else { return }
            
            router.navigate(to: .applySpecialOffer) { applyOfferVC in
                guard let applyOfferVC = applyOfferVC as? ApplyOfferViewController else { print("We can't cast to ApplyOfferViewController"); return }
                applyOfferVC.configureViewController(specialOffer)
            }
        }
    }

}

// MARK: - Setup UI
private extension ProfileViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(headerView, scrollView)

        setupScrollView()

        setupLayout()
    }

    func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubviews(contentStackView)
    }

    func setupLayout() {
        setupScrollViewLayout()
        setupContentStackViewLayout()
    }

    func setupScrollViewLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: topInset),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func setupContentStackViewLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
}
