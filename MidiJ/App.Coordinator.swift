//
//  App.Coordinator.swift
//  MidiJ
//
//  Created by me on 17/04/2023.
//

import Foundation
import Combine
import SwiftUI

extension App {
    
    class Coordinator {
        let mainViewController: MainView.Controller
        let settingsViewController: SettingsView.Controller
        
        private var cancelables = Set<AnyCancellable>()
        
        private let settingsVisibilityLogic: SettingsVisibilityLogic
        
        init() {
            let settingsViewController = SettingsView.Controller()
            let settingsNavigationController = Reactive.NavigationController(rootViewController: settingsViewController)
            
            let onMenuButtonTap = PassthroughSubject<Void, Never>()
            let settingsVisibilityLogic = SettingsVisibilityLogic(
                onMenuButtonTap: onMenuButtonTap,
                onDidShowViewController: settingsNavigationController
                    .streams
                    .didShowViewController
            )
            
            
            self.settingsViewController = settingsViewController
            
            self.mainViewController = .init(
                settingsViewController: settingsNavigationController,
                viewModel: .init(
                    menuButtonContainerViewModel: .init(
                        onMenuButtonTap: onMenuButtonTap,
                        menuVisibility: settingsVisibilityLogic.menuVisibilityState.eraseToAnyPublisher()
                    )
                )
            )
            
            self.settingsVisibilityLogic = settingsVisibilityLogic
            
            settingsVisibilityLogic
                .shouldSettingBeVisible
                .sink { [weak self] isHidden in
                    self?.settingsViewController.view.set(
                        isHidden: isHidden,
                        animatedUsing: .layoutAnimator
                    )
                    self?.settingsViewController.navigationController?.view.isUserInteractionEnabled = !isHidden
                }
                .store(in: &cancelables)
            
            settingsVisibilityLogic
                .startDisplayingSettingsViewController
                .sink { [weak mainViewController] _ in
                    mainViewController?.startDisplayingSettingsViewController()
                }
                .store(in: &cancelables)
            
            settingsVisibilityLogic
                .popSettingsNavigationController
                .sink { [weak settingsNavigationController] _ in
                    settingsNavigationController?.popViewController(animated: true)
                }
                .store(in: &cancelables)
        }
    }
}
