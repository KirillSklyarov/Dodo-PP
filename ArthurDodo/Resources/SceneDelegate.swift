//
//  SceneDelegate.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 17.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let vc = MainViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}

