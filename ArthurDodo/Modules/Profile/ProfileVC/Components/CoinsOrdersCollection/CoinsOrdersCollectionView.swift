import UIKit

final class CoinsOrdersCollectionView: UICollectionView {

    // MARK: - Properties
    private let cellHeight: CGFloat = 200
    private let cellWidth: CGFloat = 150
    private let lineSpacing: CGFloat = 5
    private var collectionHeight: CGFloat = 200
    private let countOfItems = 3

    var onToppingSelected: ( (Int) -> Void )?

    private var personalData: Personal?
    private var state: ScreenState = .loading

    // MARK: - Init
    override init(frame: CGRect = .zero, collectionViewLayout layout: UICollectionViewLayout = UICollectionViewLayout()) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        let customLayout = configLayout()
        collectionViewLayout = customLayout
        configureCollectionView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension CoinsOrdersCollectionView {
    func getPersonalData(_ personalData: Personal) {
        self.personalData = personalData
        reloadData()
    }

    func setState(_ state: ScreenState) {
        self.state = state
        reloadCollection()
    }
}

// MARK: - Setup Layout
private extension CoinsOrdersCollectionView {
    func configureCollectionView() {
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false

        register(CoinsOrdersCollectionViewCell.self, forCellWithReuseIdentifier: CoinsOrdersCollectionViewCell.identifier)
        register(SkeletonCollectionViewCell.self, forCellWithReuseIdentifier: SkeletonCollectionViewCell.identifier)
        register(ErrorCollectionViewCell.self, forCellWithReuseIdentifier: ErrorCollectionViewCell.identifier)

        dataSource = self
        delegate = self
    }

    func setupLayout() {
        heightAnchor.constraint(equalToConstant: collectionHeight).isActive = true
    }

    func configLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = 1
        return layout
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension CoinsOrdersCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .loading: return 1
        case .success: return countOfItems
        case .error: return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch state {
        case .loading:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkeletonCollectionViewCell.identifier, for: indexPath) as? SkeletonCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case .success:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinsOrdersCollectionViewCell.identifier, for: indexPath) as? CoinsOrdersCollectionViewCell else { return UICollectionViewCell() }
            guard let personalData else { return cell }
            cell.configureCell(indexPath, data: personalData)
            return cell
        case .error:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ErrorCollectionViewCell.identifier, for: indexPath) as? ErrorCollectionViewCell else { return UICollectionViewCell() }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch state {
        case .loading: return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        case .success: return CGSize(width: cellWidth, height: cellHeight)
        case .error: return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
}

// MARK: - Supporting methods
private extension CoinsOrdersCollectionView {

}
