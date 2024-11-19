//
//  UIView+Ext.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 17.09.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

    }

    func setBorder(_ color: UIColor = .white) {
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
    }
}
