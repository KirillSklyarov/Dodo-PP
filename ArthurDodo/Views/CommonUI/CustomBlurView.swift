//
//  BlurView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 02.10.2024.
//

import UIKit

final class CustomBlurView: UIVisualEffectView {

    override init(effect: UIVisualEffect? = nil) {
        super.init(effect: effect ?? UIBlurEffect(style: .systemUltraThinMaterialDark))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
