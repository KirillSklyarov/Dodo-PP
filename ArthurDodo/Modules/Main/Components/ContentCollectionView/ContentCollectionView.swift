//
//  ContentCollectionView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 05.10.2024.
//

import UIKit

final class ContentCollectionView: UICollectionView {

    // MARK: - Properties
    private var categoryHeaderView: CategoriesHeaderView?
    private var isScrolling = false
    private var stories: [Story] = []
    private var specialOffersArray: [Item] = []
    private var catalog: [Item] = []
    private var categories: [CategoryName] = []

    private let countOfSections = 3

    var onItemCellTapped: ((IndexPath) -> Void)?
    var onStoriesCellTapped: ((IndexPath) -> Void)?
    var onSpecialOfferCellTapped: ((IndexPath) -> Void)?

    private let storage = DataStorage.shared

    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewLayout()
        super.init(frame: frame, collectionViewLayout: layout)

        let customLayout = createCompositionalLayout()
        self.collectionViewLayout = customLayout
        configCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func didMoveToSuperview() {
        setupLayout()
    }
}

// MARK: - Fetch data
extension ContentCollectionView {
    // Забираем данные из хранилища и обновляем секцию со сторис
    func uploadDataFromStorage() {
        fetchData()
        updateUI()
    }

    func fetchData() {
        stories = storage.fetchedStories
        specialOffersArray = storage.getSpecialOffersArray()
        catalog = storage.getCatalog()
        categories = storage.getCategories()
    }

    func updateUI() {
        categoryHeaderView?.updateUI()
        reloadData()
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(90), heightDimension: .absolute(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)

        return section
    }

    func configureSpecialOfferSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(225), heightDimension: .absolute(90))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65), heightDimension: .absolute(90))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )

        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    func createItemsSectionWithHeader() -> NSCollectionLayoutSection {
        var allGroups: [NSCollectionLayoutGroup] = []
        var totalHeight = CGFloat(0)

        if categories.isEmpty {
            let placeholderItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
            let placeholderItem = NSCollectionLayoutItem(layoutSize: placeholderItemSize)

            let placeholderGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
            let placeholderGroup = NSCollectionLayoutGroup.vertical(layoutSize: placeholderGroupSize, subitems: [placeholderItem])

            allGroups.append(placeholderGroup)
            totalHeight += placeholderGroupSize.heightDimension.dimension
        } else {
            for cat in categories {
                let firstItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
                let firstItem = NSCollectionLayoutItem(layoutSize: firstItemSize)

                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let firstGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
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
    }

    func configCollectionView() {
        backgroundColor = AppColors.backgroundGray
        layer.cornerRadius = 14
        layer.masksToBounds = true
        register(StoriesCollectionCell.self, forCellWithReuseIdentifier: StoriesCollectionCell.identifier)
        register(SpecialOfferCollectionCell.self, forCellWithReuseIdentifier: SpecialOfferCollectionCell.identifier)
        register(SpecialOfferHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SpecialOfferHeaderView.identifier)
        register(CategoriesHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoriesHeaderView.identifier)

        register(ItemsHeaderView.self, forCellWithReuseIdentifier: ItemsHeaderView.identifier)
        register(ItemsCollectionCell.self, forCellWithReuseIdentifier: ItemsCollectionCell.identifier)

        delegate = self
        dataSource = self
        translatesAutoresizingMaskIntoConstraints = false
    }

    func setupLayout() {
        guard let superview else { return }

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ContentCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        countOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return stories.count
        case 1: return specialOffersArray.count
        case 2: return catalog.count
        default : return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoriesCollectionCell.identifier, for: indexPath) as? StoriesCollectionCell else { return UICollectionViewCell() }
            let story = stories[indexPath.item]
            cell.configureCell(story)
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpecialOfferCollectionCell.identifier, for: indexPath) as? SpecialOfferCollectionCell else { return UICollectionViewCell() }
            let item = specialOffersArray[indexPath.item]
            cell.configureCell(item)
            return cell
        case 2:
            let item = catalog[indexPath.item]

            if item.isHeader {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemsHeaderView.identifier, for: indexPath) as? ItemsHeaderView else {
                    return UICollectionViewCell() }
                let item = catalog[indexPath.item]
                cell.configHeader(item)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemsCollectionCell.identifier, for: indexPath) as? ItemsCollectionCell else {
                    return UICollectionViewCell() }
                cell.configureCell(item)
                return cell
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
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SpecialOfferHeaderView.identifier, for: indexPath) as! SpecialOfferHeaderView
            header.setTitle("Вам понравится")
            return header
        case 2:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CategoriesHeaderView.identifier, for: indexPath) as! CategoriesHeaderView
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
