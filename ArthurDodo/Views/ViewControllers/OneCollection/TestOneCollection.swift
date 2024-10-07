//
//  TestOneCollection.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 05.10.2024.
//

import UIKit

final class TestOneCollection: UICollectionView {

    // MARK: - Properties
    var categoryHeaderView: CategoriesHeaderView?
    var isScrolling = false

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

    // MARK: - Data binding
    private func dataBinding() {
        categoryCellSelected()
    }

    private func categoryCellSelected() {
        categoryHeaderView?.onCategorySelected = { [weak self] category in
            guard let self else { return }
            let selectedIndex = allItems.firstIndex{ $0.category == category } ?? 0
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
extension TestOneCollection {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10

        return UICollectionViewCompositionalLayout(sectionProvider:  { (section, _) -> NSCollectionLayoutSection? in
            switch section {
            case 0: return self.createHorizontalSection()
            case 1: return self.createHorizontalSpecialOfferSection()
            case 2: return self.createItemsSectionWithHeader()

            default: return nil
            }
        }, configuration: config)
    }

    private func createHorizontalSection() -> NSCollectionLayoutSection {
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

    private func createHorizontalSpecialOfferSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(210), heightDimension: .absolute(90))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .absolute(90))
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

    private func createCategorySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(40), heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        return section
    }

//    private func createItemsSection() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuous
//        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
//
//        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))

    private func createItemsSectionWithHeader() -> NSCollectionLayoutSection {
        var allGroups: [NSCollectionLayoutGroup] = []
        var totalHeight = CGFloat(0)

        for cat in categories {
            let firstItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
            let firstItem = NSCollectionLayoutItem(layoutSize: firstItemSize)

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let firstGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
            let firstGroup = NSCollectionLayoutGroup.vertical(layoutSize: firstGroupSize, subitems: [firstItem])

            let groupHeight = itemSize.heightDimension.dimension * CGFloat(cat.items.count - 1)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(groupHeight))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let comboGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(firstGroupSize.heightDimension.dimension + groupHeight))
            let comboGroup = NSCollectionLayoutGroup.vertical(layoutSize: comboGroupSize, subitems: [firstGroup, group])

            totalHeight += comboGroupSize.heightDimension.dimension
            allGroups.append(comboGroup)
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

    private func configCollectionView() {
        backgroundColor = AppColors.backgroundGray
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 14
        layer.masksToBounds = true
        register(StoriesCollectionCell.self, forCellWithReuseIdentifier: StoriesCollectionCell.identifier)
        register(SpecialOfferCollectionCell.self, forCellWithReuseIdentifier: SpecialOfferCollectionCell.identifier)
        register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.identifier)
        register(CategoriesHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoriesHeaderView.identifier)

        register(ItemsHeaderView.self, forCellWithReuseIdentifier: ItemsHeaderView.identifier)
        register(ProductCollectionCell.self, forCellWithReuseIdentifier: ProductCollectionCell.identifier)

        delegate = self
        dataSource = self
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        guard let superview else { return }

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TestOneCollection: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return categories.count
        case 1: return 4
        case 2: return allItems.count
        default : return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoriesCollectionCell.identifier, for: indexPath) as? StoriesCollectionCell else { return UICollectionViewCell() }
            let title = categories[indexPath.row].header.rawValue
            cell.configHeader(title)
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.white.cgColor
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpecialOfferCollectionCell.identifier, for: indexPath) as? SpecialOfferCollectionCell else { return UICollectionViewCell() }
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.white.cgColor
            return cell
        case 2:
            let item = allItems[indexPath.row]

            if item.isHeader {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemsHeaderView.identifier, for: indexPath) as? ItemsHeaderView else {
                    return UICollectionViewCell() }
                let item = allItems[indexPath.row]
                cell.configHeader(item)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionCell.identifier, for: indexPath) as? ProductCollectionCell else {
                    return UICollectionViewCell() }
                cell.configureCell(pizza: item)
                return cell
            }
        default: return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case 0: print("Selected story at index \(indexPath.row)")
        case 1: print("Selected special offer at index \(indexPath.row)")
        case 2: print("Selected item at index \(indexPath)")
        default : return
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let section = indexPath.section

        switch section {
        case 1:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.identifier, for: indexPath) as! CollectionHeaderView
            header.setTitle("Вам понравится")
            return header
        case 2:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CategoriesHeaderView.identifier, for: indexPath) as! CategoriesHeaderView
            categoryHeaderView = header
            dataBinding()
            return header
        default: return UICollectionReusableView()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension TestOneCollection {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isScrolling {
            guard let index = indexPathsForVisibleItems.sorted().first?.item else { return }
            let catOnScreen = allItems[index].category.rawValue
            categoryHeaderView?.getCategory(catOnScreen)
        }
    }
}
