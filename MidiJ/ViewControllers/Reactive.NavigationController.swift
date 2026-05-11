//
//  Reactive.NavigationController.swift
//  MidiJ
//
//  Created by me on 21/05/2023.
//

import Foundation
import Combine
import UIKit

extension Reactive {
    final class NavigationController: UINavigationController, UINavigationControllerDelegate {
        struct Streams {
            let didShowViewController: any Publisher<UIViewController, Never>
        }
        
        let didShowViewController = PassthroughSubject<UIViewController, Never>()
        
        var streams: Streams {
            .init(didShowViewController: didShowViewController.eraseToAnyPublisher())
        }
        
        override init(rootViewController: UIViewController) {
            super.init(rootViewController: rootViewController)
         
            delegate = self
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func navigationController(
            _ navigationController: UINavigationController,
            didShow viewController: UIViewController,
            animated: Bool
        ) {
            didShowViewController.send(viewController)
        }
    }
}
