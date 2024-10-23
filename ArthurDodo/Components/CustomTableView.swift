//
//  CustomTableView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 23.10.2024.
//

import UIKit


// Этот класс таблицы позволяет не выставлять высоту, она высчитывается автоматом
final class AppTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: contentSize.width, height: contentSize.height)
    }
}
