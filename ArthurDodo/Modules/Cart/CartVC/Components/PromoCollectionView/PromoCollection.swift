import UIKit

final class PromoCollectionView: UICollectionView {

    // MARK: - Properties
    private let collectionHeight: CGFloat = 180
    var onShowNewCell: ( (Int) -> Void )?
    var onCellSelected: ( (Promo) -> Void )?

    private var promo: [Promo] = []

    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal

        super.init(frame: frame, collectionViewLayout: collectionLayout)
        configCollectionView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PromoCollectionView {
    // Получаем акции и обновляем коллекцию
    func updateUI(_ promo: [Promo]) {
        self.promo = promo
        reloadCollection()
    }
}

// MARK: - Setup UI
private extension PromoCollectionView {
    func configCollectionView() {
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        registerCell(PromoCollectionCell.self)
        dataSource = self
        delegate = self
    }

    func setupLayout() {
        heightAnchor.constraint(equalToConstant: collectionHeight).isActive = true
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension PromoCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        promo.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(indexPath) as PromoCollectionCell
        let item = promo[indexPath.item]
        cell.configureCell(item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = promo[indexPath.item]
        onCellSelected?(item)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionHeight
        return CGSize(width: width, height: height)
    }
}

// Настройка page control - что переключался при скролле
extension PromoCollectionView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let page = Int((scrollView.contentOffset.x + (0.5 * pageWidth)) / pageWidth)
        onShowNewCell?(page)
    }
}
