//
//  YPad.DotsView.swift
//  MidiJ
//
//  Created by me on 25/07/2022.
//

import Foundation
import OnionUI
import UIKit

extension YPad {
    
    class DotsView: StrictlySetupView {

        var isHeld: Bool = false {
            didSet {
                setupViewColors()
            }
        }
        
        private var dotViews = [UIView]()
        
        override func setupViewColors() {
            dotViews.forEach { dotView in
                dotView.backgroundColor = .Constants.yPadDotColors.forState(isHighlighted: isHeld)
            }
        }
        
        override func setupViewHierarchy() {
            addPinnedSubView(withPadding: .init(top: .Constants.spacing10, left: .Constants.spacing10, bottom: -.Constants.spacing10, right: -.Constants.spacing10)) {
                UIStackView()
                    .horizontalize()
                    .setting(distribution: .equalSpacing)
                    .addArrangedSubViews(6.timesMake(makeElement: {
                        UIStackView()
                            .verticalize()
                            .setting(distribution: .equalSpacing)
                            .addArrangedSubViews(22.timesMake(makeElement: {
                                UIView()
                                    .setting(layerCornerRadius: 1)
                                    .layedOutWith { layout in
                                        layout.setWidth(to: 2)
                                        layout.setHeight(to: 2)
                                    }
                                    .use { it in
                                        self.dotViews.append(it)
                                    }
                            }))
                            
                    }))
            }
        }
    }
}
