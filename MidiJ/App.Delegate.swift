//
//  AppDelegate.swift
//  MidiJ
//
//  Created by User on 21/01/2022.
//

import UIKit

extension App {
    @main
    class Delegate: UIResponder, UIApplicationDelegate {
        
        var window: UIWindow?
        
        private let coordinator = Coordinator()
        
        func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
            window = UIWindow(frame: UIScreen.main.bounds).mutated { it in
                it.rootViewController = coordinator.mainViewController
                it.makeKeyAndVisible()
            }
            
            return true
        }
        
        func application(
            _ application: UIApplication,
            supportedInterfaceOrientationsFor window: UIWindow?
        ) -> UIInterfaceOrientationMask {
            .portrait
        }
    }
}

