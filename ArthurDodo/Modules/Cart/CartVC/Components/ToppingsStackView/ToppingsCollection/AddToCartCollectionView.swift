import UIKit

final class AddToCartCollectionView: UICollectionView {

    // MARK: - Properties
    private let cellHeight: CGFloat = 215
    private let cellSpacing: CGFloat = 10
    private let countOfCellsInRow: CGFloat = 3
    private let leftAndRightPadding: CGFloat = 20
    private let numberOfElements = 5
    private var correctWidth: CGFloat {
        (UIScreen.main.bounds.width - (cellSpacing * 2) - leftAndRightPadding) / countOfCellsInRow
    }

    private var itemsToAddToOrder: [Item] = []

    private var state: ScreenState = .loading

    var onToppingSelected: ( (Int) -> Void )?
    var onNewItemToAddToCart: ( (Order) -> Void )?

    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        let customLayout = configLayout()
        collectionViewLayout = customLayout
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Получаем товары, для отражения в корзине в категории "Добавить к заказу"
    func getItemsToAddToOrder(_ items: [Item]) {
        itemsToAddToOrder = items
    }

    func setState(_ state: ScreenState) {
        self.state = state
        reloadData()
    }
}

// MARK: - Setup UI
private extension AddToCartCollectionView {
    func setupUI() {
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        register(AddToCartCollectionCell.self, forCellWithReuseIdentifier: AddToCartCollectionCell.identifier)
        register(SkeletonCollectionViewCell2.self, forCellWithReuseIdentifier: SkeletonCollectionViewCell2.identifier)

        dataSource = self
        delegate = self

        setupLayout()
    }

    func setupLayout() {
        heightAnchor.constraint(equalToConstant: cellHeight).isActive = true
    }

    func configLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: correctWidth, height: cellHeight)
        return layout
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension AddToCartCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .loading: return 1
        case .success: return numberOfElements
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch state {
        case .loading:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkeletonCollectionViewCell2.identifier, for: indexPath) as? SkeletonCollectionViewCell2 else { return UICollectionViewCell() }
            return cell
        case .success:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddToCartCollectionCell.identifier, for: indexPath) as? AddToCartCollectionCell else { return UICollectionViewCell() }
            let itemToAdd = itemsToAddToOrder[indexPath.row]
            cell.configCell(itemToAdd)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch state {
        case .loading: return CGSize(width: collectionView.frame.width, height: cellHeight)
        case .success: return CGSize(width: correctWidth, height: cellHeight)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let positionToAdd = getOrderFromIndexPath(indexPath)
        print("positionToAdd \(positionToAdd)")
        addItemToOrder(positionToAdd)
    }

    private func getOrderFromIndexPath(_ indexPath: IndexPath) -> Order {
        let itemToAdd = itemsToAddToOrder[indexPath.row]
        let positionToAdd = castOrderFromItem(itemToAdd)
        return positionToAdd
    }

    func castOrderFromItem(_ item: Item) -> Order {
        let size = item.getCorrectSize()
        let price = item.getCorrectPrice()
        let dough: Dough? = item.category == .pizza ? .basic : nil
        let weight = item.getCorrectWeight()

        let order = Order(itemName: item.name, imageName: item.imageName, size: size, dough: dough, weight: weight, price: price, isHit: item.isHit)
        return order
    }

    private func addItemToOrder(_ item: Order) {
        onNewItemToAddToCart?(item)
    }
}
