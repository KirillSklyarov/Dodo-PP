//
//  CustomPageControl.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 27.09.2024.
//

import UIKit

final class CustomPageControl: UIPageControl {

    var onPageChange: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPageControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPageControl() {
        numberOfPages = 2
        isUserInteractionEnabled = false
        currentPageIndicatorTintColor = .white
        pageIndicatorTintColor = .lightGray
        addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
        let config = UIImage.SymbolConfiguration(pointSize: 26, weight: .bold)
        preferredIndicatorImage = UIImage(systemName: "minus", withConfiguration: config)
    }

    @objc private func pageControlValueChanged(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        onPageChange?(currentPage)
    }
}
