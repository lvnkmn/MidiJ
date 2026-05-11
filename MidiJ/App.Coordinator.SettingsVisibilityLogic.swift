//
//  App.Coordinator.SettingsVisibilityLogic.swift
//  MidiJ
//
//  Created by me on 21/07/2023.
//

import Combine
import UIKit

extension App.Coordinator {
    struct SettingsVisibilityLogic {
        internal init(
            onMenuButtonTap: any Publisher<Void, Never>,
            onDidShowViewController: any Publisher<UIViewController, Never>
        ) {
            let displayedViewController = onDidShowViewController.eraseToAnyPublisher().share()
            
            let menuDepth = displayedViewController
                .map { displayedViewController in
                    MenuButton.MenuVisibility.MenuDepth.neededDepth(
                        consideringDisplayingOfViewController: displayedViewController
                    )
                }
                .eraseToAnyPublisher()
            
            let shouldSettingBeVisible: AnyPublisher<Bool, Never> = onMenuButtonTap
                .eraseToAnyPublisher()
                .withLatestFrom(menuDepth)
                .filter { menuDepth in
                    menuDepth.isDisplayedAtRoot
                }
                .scan(false, { previous, _ in
                    !previous
                })
                .prepend(true)
                .eraseToAnyPublisher()
            
            let menuVisibilityState: AnyPublisher<MenuButton.MenuVisibility, Never> = shouldSettingBeVisible
                .combineLatest(menuDepth)
                .eraseToAnyPublisher()
                .map { shouldSettingsBeVisible, menuDepth in
                    MenuButton.MenuVisibility(
                        isHidden: !shouldSettingsBeVisible,
                        menuDepth: menuDepth
                    )
                }
                .prepend(MenuButton.MenuVisibility.initial)
                .share()
                .eraseToAnyPublisher()
            
            self.startDisplayingSettingsViewController = onMenuButtonTap
                .eraseToAnyPublisher()
                .prefix(1)
            
            self.menuVisibilityState = menuVisibilityState
            
            self.shouldSettingBeVisible = menuVisibilityState
                .map(\.isHidden)
                .removeDuplicates()
            
            self.popSettingsNavigationController = onMenuButtonTap
                .eraseToAnyPublisher()
                .withLatestFrom(menuVisibilityState)
                .filter { state in
                    state.menuDepth == .displayedAtSubLevel
                }
                .map { _ in
                    Void()
                }
        }
        
        let shouldSettingBeVisible: any Publisher<Bool, Never>
        let popSettingsNavigationController: any Publisher<Void, Never>
        let menuVisibilityState: any Publisher<MenuButton.MenuVisibility, Never>
        let startDisplayingSettingsViewController: any Publisher<Void, Never>
    }
}

private extension MenuButton.MenuVisibility.MenuDepth {
    
    static func neededDepth(
        consideringDisplayingOfViewController displayedViewController: UIViewController
    ) -> MenuButton.MenuVisibility.MenuDepth {
        displayedViewController.isRootOfNavigationController ?
            .displayedAtRoot :
            .displayedAtSubLevel
    }
}

private extension UIViewController {
    var isRootOfNavigationController: Bool {
        navigationController
            .map { navigationController in
                navigationController.viewControllers.first === self
            }
        ?? false
    }
}
