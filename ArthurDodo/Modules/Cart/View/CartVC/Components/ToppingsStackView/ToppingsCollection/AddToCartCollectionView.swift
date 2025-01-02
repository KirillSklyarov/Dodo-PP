import UIKit

// Это коллекция, которая отвечает за добавление новой позиции к действующему заказу (блок "Добавить к заказу")
final class AddToCartCollectionView: UICollectionView {

    // MARK: - Properties
    private let cellHeight: CGFloat = 240
    private let cellSpacing: CGFloat = 10
    private let countOfCellsInRow: CGFloat = 2.5
    private let leftAndRightPadding: CGFloat = 20
    private let numberOfElements = 5
    private var correctWidth: CGFloat {
        (UIScreen.main.bounds.width - (cellSpacing * 2) - leftAndRightPadding) / countOfCellsInRow
    }

    private var itemsToAddToOrder: [Item] = []

    private var state: ScreenState = .loading

    var onToppingSelected: ( (Int) -> Void )?
    var onNewItemToAddToCart: ( (CartItem) -> Void )?

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
        registerCell(AddToCartCollectionCell.self)
        registerCell(SkeletonCollectionViewCell2.self)

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
        case .initial: return 1
        case .loading: return 1
        case .success: return numberOfElements
        case .error: return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch state {
        case .initial: return UICollectionViewCell()
        case .loading:
            let cell = collectionView.dequeueCell(indexPath) as SkeletonCollectionViewCell2
            return cell
        case .success:
            let cell = collectionView.dequeueCell(indexPath) as AddToCartCollectionCell
            let itemToAdd = itemsToAddToOrder[indexPath.row]
            cell.configCell(itemToAdd)
            return cell
        case .error: return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch state {
        case .initial: return CGSize(width: collectionView.frame.width, height: cellHeight)
        case .loading: return CGSize(width: collectionView.frame.width, height: cellHeight)
        case .success: return CGSize(width: correctWidth, height: cellHeight)
        case .error: return CGSize(width: collectionView.frame.width, height: cellHeight)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let positionToAdd = getItemFromIndexPath(indexPath)
        addItemToCart(positionToAdd)
    }

    private func getItemFromIndexPath(_ indexPath: IndexPath) -> CartItem {
        let itemToAdd = itemsToAddToOrder[indexPath.row]
        let positionToAdd = castOrderFromItem(itemToAdd)
        return positionToAdd
    }

    private func castOrderFromItem(_ item: Item) -> CartItem {
        let size = item.getCorrectSize()
        let dough: Dough? = item.category == .pizza ? .basic : nil
        let weight = item.getWeight(size: size)
        let price = item.getCorrectPrice()
        let isOneSize = item.hasOneSize()

        let cartPosition = CartItem(item: item, chosenSize: size, chosenDough: dough, weight: weight, price: price, isOneSize: isOneSize)

        return cartPosition
    }

    private func addItemToCart(_ item: CartItem) {
        onNewItemToAddToCart?(item)
    }
}
