//
//  UICollection+Ext.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 03.10.2024.
//

import UIKit

extension UICollectionView {
    // Получаем все видимые элементы в заданной области
    func indexPathsForVisibleItemsInRect(_ rect: CGRect) -> [IndexPath]? {
        let layoutAttributes = self.collectionViewLayout.layoutAttributesForElements(in: rect)
        return layoutAttributes?.map { $0.indexPath }
    }
}
