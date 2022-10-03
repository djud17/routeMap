//
//  SceneDelegate.swift
//  taskMap
//
//  Created by Давид Тоноян  on 03.10.2022.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MapViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
}

