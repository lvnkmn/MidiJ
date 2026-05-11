//
//  MainView.swift
//  MidiJ
//
//  Created by Menno Lovink on 24/01/2023.
//

import Foundation
import SwiftUI
import UIKit
import OnionUI
import LazyLayout
import SourceSeeds
import Combine

class MainView: StrictlySetupView, HasTemporaryLayoutConstraints {
    struct ViewModel {
        let menuButtonContainerViewModel: MenuButtonsContainer.ViewModel
    }
    
    let menuContainer: MenuButtonsContainer
    
    let performanceView = PerformanceView()

    var isMenuVisible: Bool = true {
        didSet {
            guard
                isMenuVisible != oldValue,
                hasBeenLayedOutBefore
            else {
                return
            }
            setupViewProperties()
            relayout(animator: .layoutAnimator)
        }
    }
    
    var temporaryLayoutConstraints = [NSLayoutConstraint?]()
    
    /// Allows prevention of layoutIfNeeded being called too early
    private var hasBeenLayedOutBefore = false
    
    init(viewModel: ViewModel) {
        self.menuContainer = MenuButtonsContainer(viewModel: viewModel.menuButtonContainerViewModel)
            .layedOutWith { layout in
                layout.setHeight(to: 50)
            }
            .setting(backgroundColor: .Constants.settingsViewBackground)
            .setting(layerCornerRadius: .Constants.cornerRadius24)
            .setting(clipsToBounds: true)
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViewHierarchy() {
        addSubViews {
            performanceView
            menuContainer
        }
    }
    
    override func setupViewProperties() {
        menuContainer.isHidden = !isMenuVisible
        clipsToBounds = true
    }
    
    override func setupViewLayout() {
        temporaryLayoutConstraints += menuContainer.layout.pin(toEdges: .horizontal)
        
        temporaryLayoutConstraints += performanceView.layout.pin(toEdges: .horizontal)
        temporaryLayoutConstraints += [performanceView.layout.pin(toEdge: .bottom)]
        
        if isMenuVisible {
            temporaryLayoutConstraints += [performanceView.layout.below(menuContainer).with(constant: .Constants.spacing16)]
            temporaryLayoutConstraints += [menuContainer.layout.pin(toEdge: .top)]
        } else {
            temporaryLayoutConstraints += [performanceView.layout.pin(toEdge: .top)]
        }
        hasBeenLayedOutBefore = true
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(
            viewModel:
                    .init(
                        menuButtonContainerViewModel:
                                .init(
                                    onMenuButtonTap:
                                        PassthroughSubject(),
                                    menuVisibility:
                                        AnyPublisher<MenuButton.MenuVisibility, Never>.just(value: .initial)
                                )
                    )
        ).represendedAsView
        MainView(
            viewModel:
                    .init(
                        menuButtonContainerViewModel:
                                .init(
                                    onMenuButtonTap:
                                        PassthroughSubject(),
                                    menuVisibility:
                                        AnyPublisher<MenuButton.MenuVisibility, Never>.just(value: .initial)
                                )
                    )
        ).mutated {
            $0.isMenuVisible = false
        }
        .represendedAsView
    }
}
