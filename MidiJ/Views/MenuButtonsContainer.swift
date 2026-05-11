//
//  ContextAwareMenuButtonsContainer.swift
//  MidiJ
//
//  Created by me on 16/01/2023.
//

import SwiftUI
import UIKit
import OnionUI
import SourceSeeds
import Combine

class MenuButtonsContainer: UIView {
    let menuButton: Control
    let connectionButton = ConnectionButton()
    
    struct ViewModel {
        let onMenuButtonTap: any Subject<Void, Never>
        let menuVisibility: any Publisher<MenuButton.MenuVisibility, Never>
    }

    init(viewModel: ViewModel) {
        self.menuButton = MenuButton(menuVisibility: viewModel.menuVisibility)
            .tappable {
                viewModel.onMenuButtonTap.send(())
            }
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MenuButtonsContainer: SettingUpViews {
 
    func setupViewProperties() {
        backgroundColor = .Constants.settingsViewBackground
    }
    
    func setupViewHierarchy() {
        addPinnedSubView(withPadding: .init(top: .zero, left: .Constants.spacing24, bottom: .zero, right: -.Constants.spacing24)) {
            UIStackView()
                .horizontalize()
                .setting(allignment: .center)
                .addArrangedSubViews {
                    menuButton
                    UIView()
                    connectionButton
                }
        }
    }
}

struct MenuButtonsContainer_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MenuButtonsContainer(
                viewModel: .init(onMenuButtonTap: PassthroughSubject(), menuVisibility: Just(.initial)))
            .mutated {
                $0.connectionButton.textLabel.setting(text: "MIDI")
            }.represendedAsView
        }
    }
}

extension UIButton.Configuration: Mutatable {}
