//
//  SceneDelegate.swift
//  ClosureTodo
//
//  Created by hansol on 2023/12/31.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        // 의존성 주입
        let closureViewModel = ClosureViewModel()
        let viewController = ViewController(closureVM: closureViewModel)
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
    
    
}

