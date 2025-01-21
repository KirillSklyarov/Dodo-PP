import UIKit
import AppUIComponentsSPM

final class ContentCollectionView: UICollectionView {

    // MARK: - Properties
    private var categoryHeaderView: CategoriesHeaderView? // Это хэдер с названиями категорий
    private var isScrolling = false // Свойство показывает скроллится ли коллекция прямо сейчас, когда нажали на категорию

    // Тут блок с данными
    private var stories: [Story] = []
    private var specialOffersArray: [Item] = []
    private var catalog: [Item] = []
    private var categories: [Category] = []

    private let countOfSections = 3 // Указываем кол-во секций в коллекции

    private var state: ScreenState = .loading // Состояние экрана

    // Замыкания:  на сторис, на спецпредложение, нажатие на товар,
    var onStoriesCellTapped: ((IndexPath) -> Void)?
    var onSpecialOfferCellTapped: ((IndexPath) -> Void)?
    var onItemCellTapped: ((IndexPath) -> Void)?

    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewLayout()
        super.init(frame: .zero, collectionViewLayout: layout)

        let customLayout = createCompositionalLayout()
        self.collectionViewLayout = customLayout
        configCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension ContentCollectionView {
    func setState(_ state: ScreenState) {
        self.state = state
        reloadUI()
    }
}

// MARK: - Fetch data
// Получаем все данные из MainVC
extension ContentCollectionView {
    // Получаем список категорий
    func getCategories(_ categories: [Category]) {
        self.categories = categories
        passCategoriesToNextView()
    }

    // Получаем список сторис
    func getStories(_ stories: [Story]) {
        self.stories = stories
    }

    // Получаем список спецпредложений
    func getSpecialOffers(_ specialOffers: [Item]) {
        self.specialOffersArray = specialOffers
    }

    // Получаем каталог
    func getCatalog(_ catalog: [Item]) {
        self.catalog = catalog
    }
}

// MARK: - Supporting methods
private extension ContentCollectionView {
    func reloadUI() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
            self?.categoryHeaderView?.updateUI()
        }
    }

    func passCategoriesToNextView() {
        categoryHeaderView?.passCategories(categories)
    }
}

// MARK: - Setup Actions
private extension ContentCollectionView {
    func setupActions() {
        categoryCellSelected()
    }

    func categoryCellSelected() {
        categoryHeaderView?.onCategorySelected = { [weak self] category in
            guard let self else { return }
            let selectedIndex = catalog.firstIndex{ $0.category == category } ?? 0
            let indexPath = IndexPath(row: selectedIndex, section: 2)
            isScrolling = true
            scrollToItem(at: indexPath, at: .top, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                self?.isScrolling = false
            }
        }
    }
}

// MARK: - Config Layout
private extension ContentCollectionView {
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10

        return UICollectionViewCompositionalLayout(sectionProvider:  { (section, _) -> NSCollectionLayoutSection? in
            switch section {
            case 0: return self.configureStoriesSection()
            case 1: return self.configureSpecialOfferSection()
            case 2: return self.createItemsSectionWithHeader()
            default: return nil }
        }, configuration: config)
    }

    func configureStoriesSection() -> NSCollectionLayoutSection {
        switch state {
        case .initial:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
            return section
        case .loading:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
            return section
        case .success:
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(90), heightDimension: .absolute(120))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)

            return section
        case .error:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
            return section
        }
    }

    func configureSpecialOfferSection() -> NSCollectionLayoutSection {
        switch state {
        case .initial:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
            return section
        case .loading:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
            return section
        case .success:
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(240), heightDimension: .absolute(90))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65), heightDimension: .absolute(90))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
            
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        case .error:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
            return section
        }
    }

    func createItemsSectionWithHeader() -> NSCollectionLayoutSection {
        switch state {
        case .initial:
            let skeletonItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(350))
            let skeletonItem = NSCollectionLayoutItem(layoutSize: skeletonItemSize)

            let skeletonGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(350))
            let skeletonGroup = NSCollectionLayoutGroup.vertical(layoutSize: skeletonGroupSize, subitems: [skeletonItem])

            let section = NSCollectionLayoutSection(group: skeletonGroup)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        case .loading:
            let skeletonItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(350))
            let skeletonItem = NSCollectionLayoutItem(layoutSize: skeletonItemSize)

            let skeletonGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(350))
            let skeletonGroup = NSCollectionLayoutGroup.vertical(layoutSize: skeletonGroupSize, subitems: [skeletonItem])

            let section = NSCollectionLayoutSection(group: skeletonGroup)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        case .success:
            var allGroups: [NSCollectionLayoutGroup] = []
            var totalHeight = CGFloat(0)

            if categories.isEmpty {
                let placeholderItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300))
                let placeholderItem = NSCollectionLayoutItem(layoutSize: placeholderItemSize)

                let placeholderGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300))
                let placeholderGroup = NSCollectionLayoutGroup.vertical(layoutSize: placeholderGroupSize, subitems: [placeholderItem])

                allGroups.append(placeholderGroup)
                totalHeight += placeholderGroupSize.heightDimension.dimension
            } else {
                for cat in categories {
                    let firstItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300))
                    let firstItem = NSCollectionLayoutItem(layoutSize: firstItemSize)

                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)

                    let firstGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300))
                    let firstGroup = NSCollectionLayoutGroup.vertical(layoutSize: firstGroupSize, subitems: [firstItem])

                    let itemsInCategory = catalog.filter { $0.category == cat }.count

                    let groupHeight = itemSize.heightDimension.dimension * CGFloat(itemsInCategory - 1)
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(groupHeight))
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                    let comboGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(firstGroupSize.heightDimension.dimension + groupHeight))
                    let comboGroup = NSCollectionLayoutGroup.vertical(layoutSize: comboGroupSize, subitems: [firstGroup, group])

                    totalHeight += comboGroupSize.heightDimension.dimension
                    allGroups.append(comboGroup)
                }
            }

            let superGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(totalHeight))
            let superGroup = NSCollectionLayoutGroup.vertical(layoutSize: superGroupSize, subitems: allGroups)

            let section = NSCollectionLayoutSection(group: superGroup)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))

            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )

            sectionHeader.pinToVisibleBounds = true
            section.boundarySupplementaryItems = [sectionHeader]

            return section
        case .error:
            let skeletonItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(350))
            let skeletonItem = NSCollectionLayoutItem(layoutSize: skeletonItemSize)

            let skeletonGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(350))
            let skeletonGroup = NSCollectionLayoutGroup.vertical(layoutSize: skeletonGroupSize, subitems: [skeletonItem])

            let section = NSCollectionLayoutSection(group: skeletonGroup)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        }
    }

    func configCollectionView() {
        backgroundColor = AppColors.backgroundGray
        layer.cornerRadius = 14
        layer.masksToBounds = true

        delegate = self
        dataSource = self

        // Регистрируем ячейки сторис
        registerCell(StoriesCollectionCell.self)

        // Регистрируем ячейки спецпредложения
        registerHeader(SpecialOfferHeaderView.self)
        registerCell(SpecialOfferCollectionCell.self)

        // Регистрируем ячейки основного каталога
        registerHeader(CategoriesHeaderView.self)
        registerCell(ItemsHeaderCell.self)
        registerCell(ItemsCollectionCell.self)

        // Регистрируем скелетоны
        registerCell(SkeletonCollectionViewCell.self)
        registerCell(SkeletonCollectionViewCell2.self)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ContentCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        countOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            switch state {
            case .initial: return 1
            case .loading: return 1
            case .success: return stories.count
            case .error: return 1
            }
        case 1:
            switch state {
            case .initial: return 1
            case .loading: return 1
            case .success: return specialOffersArray.count
            case .error: return 1
            }
        case 2:
            switch state {
            case .initial: return 1
            case .loading: return 1
            case .success: return catalog.count
            case .error: return 1
            }
        default : return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            switch state {
            case .initial: return UICollectionViewCell()
            case .loading:
                let cell = collectionView.dequeueCell(indexPath) as SkeletonCollectionViewCell2
                return cell
            case .success:
                let cell = collectionView.dequeueCell(indexPath) as StoriesCollectionCell
                let story = stories[indexPath.item]
                cell.configureCell(story)
                return cell
            case .error: return UICollectionViewCell()
            }
        case 1:
            switch state {
            case .initial: return UICollectionViewCell()
            case .loading:
                let cell = collectionView.dequeueCell(indexPath) as SkeletonCollectionViewCell
                return cell
            case .success:
                let cell = collectionView.dequeueCell(indexPath) as SpecialOfferCollectionCell
                let item = specialOffersArray[indexPath.item]
                cell.configureCell(item)
                return cell
            case .error: return UICollectionViewCell()
            }
        case 2:
            switch state {
            case .initial: return UICollectionViewCell()
            case .loading:
                let cell = collectionView.dequeueCell(indexPath) as SkeletonCollectionViewCell2
                return cell
            case .success:
                let item = catalog[indexPath.item]
                if item.isHeader {
                    let cell = collectionView.dequeueCell(indexPath) as ItemsHeaderCell
                    cell.configHeader(item)
                    return cell
                } else {
                    let cell = collectionView.dequeueCell(indexPath) as ItemsCollectionCell
                    cell.configureCell(item)
                    return cell
                }
            case .error: return UICollectionViewCell()
            }
        default: return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case 0: onStoriesCellTapped?(indexPath)
        case 1: onSpecialOfferCellTapped?(indexPath)
        case 2: onItemCellTapped?(indexPath)
        default : return
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let section = indexPath.section

        switch section {
        case 1:
            let header = collectionView.dequeueHeader(indexPath) as SpecialOfferHeaderView
            header.setTitle("Вам понравится")
            return header
        case 2:
            let header = collectionView.dequeueHeader(indexPath) as CategoriesHeaderView
            categoryHeaderView = header
            setupActions()
            return header
        default: return UICollectionReusableView()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ContentCollectionView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isScrolling {
            guard let index = indexPathsForVisibleItems.sorted().first?.item else { return }
            let catOnScreen = catalog[index].category.rawValue
            categoryHeaderView?.getCategory(catOnScreen)
        }
    }
}
