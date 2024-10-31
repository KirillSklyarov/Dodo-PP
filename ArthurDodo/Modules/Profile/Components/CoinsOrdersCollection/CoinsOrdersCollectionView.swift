import UIKit
import SkeletonView

final class CoinsOrdersCollectionView: UICollectionView {

    // MARK: - Properties
    private let cellHeight: CGFloat = 200
    private let cellWidth: CGFloat = 150
    private let lineSpacing: CGFloat = 5
    private var collectionHeight: CGFloat = 200

    var onToppingSelected: ( (Int) -> Void )?

    private var personalData: Personal?

    // MARK: - Init
    init(frame: CGRect = .zero, collectionViewLayout layout: UICollectionViewLayout = UICollectionViewLayout(), personalData: Personal?) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        let customLayout = configLayout()
        collectionViewLayout = customLayout
        self.personalData = personalData
        configureCollectionView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI(_ personalData: Personal) {
        self.personalData = personalData
        reloadData()
    }

    func collectionShowSkeleton() {
        showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .carrot))
    }

    func stopShowingSkeleton() {
        stopSkeletonAnimation()
        hideSkeleton()
    }
}

// MARK: - Setup Layout
private extension CoinsOrdersCollectionView {
    func configureCollectionView() {
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        register(CoinsOrdersCollectionViewCell.self, forCellWithReuseIdentifier: CoinsOrdersCollectionViewCell.identifier)
        dataSource = self
        delegate = self

        setupSkeleton()
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
extension CoinsOrdersCollectionView: SkeletonCollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return CoinsOrdersCollectionViewCell.identifier
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinsOrdersCollectionViewCell.identifier, for: indexPath) as? CoinsOrdersCollectionViewCell else { return UICollectionViewCell() }
        guard let personalData else { return cell }
        cell.configureCell(indexPath, data: personalData)
        return cell
    }
}

// MARK: - Setup Skeleton
private extension CoinsOrdersCollectionView {
    func setupSkeleton() {
        isSkeletonable = true
    }
}

