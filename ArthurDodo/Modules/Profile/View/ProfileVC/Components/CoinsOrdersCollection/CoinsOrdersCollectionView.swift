import UIKit

final class CoinsOrdersCollectionView: UICollectionView {

    // MARK: - Properties
    private let cellHeight: CGFloat = 200
    private let cellWidth: CGFloat = 150
    private let lineSpacing: CGFloat = 5
    private var collectionHeight: CGFloat = 200
    private let countOfItems = 3

    var onToppingSelected: ( (Int) -> Void )?
    var onAddressCellTapped: ( () -> Void )?

    private var personalData: User?
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
    func getPersonalData(_ personalData: User) {
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

        registerCell(CoinsOrdersCollectionViewCell.self)
        registerCell(SkeletonCollectionViewCell.self)
        registerCell(ErrorCollectionViewCell.self)

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
        case .initial: return 1
        case .loading: return 1
        case .success: return countOfItems
        case .error: return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch state {
        case .initial:
            let cell = collectionView.dequeueCell(indexPath) as SkeletonCollectionViewCell
            return cell
        case .loading:
            let cell = collectionView.dequeueCell(indexPath) as SkeletonCollectionViewCell
            return cell
        case .success:
            let cell = collectionView.dequeueCell(indexPath) as CoinsOrdersCollectionViewCell
            guard let personalData else { return cell }
            cell.configureCell(indexPath, data: personalData)
            return cell
        case .error:
            let cell = collectionView.dequeueCell(indexPath) as ErrorCollectionViewCell
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isAddressCellTapped(indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch state {
        case .initial: return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        case .loading: return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        case .success: return CGSize(width: cellWidth, height: cellHeight)
        case .error: return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
}

// MARK: - Supporting methods
private extension CoinsOrdersCollectionView {
    func isAddressCellTapped(_ indexPath: IndexPath) {
        let lastRow = countOfItems - 1
        if indexPath.row == lastRow {
            onAddressCellTapped?()
        }
    }
}
