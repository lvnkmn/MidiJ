//
//  Fader.StripesView.swift
//  MidiJ
//
//  Created by me on 01/08/2022.
//

import OnionUI
import UIKit

extension Fader {
    class StripesView: StrictlySetupView {
        
        var closestFaderLocation: CGFloat = 0 {
            didSet {
                setupViewColors()
            }
        }
        
        var shouldHighlightUpperStripes = false {
            didSet {
                setupViewColors()
            }
        }
        
        private lazy var stripeViews = Int.numberOfVerticalStripes.timesMake {
            UIView()
                .setting(backgroundColor: .Constants.highlightedPitchfaderStripesColor)
        }
        
        override func setupViewColors() {
            for (index, view) in stripeViews.enumerated() {
                view.backgroundColor = stripeColor(forStripewWithIndex: index)
            }
        }
        
        override func setupViewHierarchy() {
            addPinnedSubView {
                UIStackView()
                    .verticalize()
                    .setting(distribution: .equalSpacing)
                    .addArrangedSubViews(stripeViews)
            }
        }
        
        override func setupViewLayout() {
            layoutMargins = .zero
            stripeViews.forEach {
                $0.layedOutWith { layout in
                    layout.setHeight(to: 2)
                }
            }
        }
    }
}

private extension Fader.StripesView {
    
    var upperColor: UIColor {
        shouldHighlightUpperStripes ? .Constants.highlightedPitchfaderStripesColor : .Constants.regularPitchfaderStripesColor
    }
    
    var lowerColor: UIColor {
        shouldHighlightUpperStripes ? .Constants.regularPitchfaderStripesColor : .Constants.highlightedPitchfaderStripesColor
    }
    
    func stripeColor(forStripewWithIndex stripeIndex: Int) -> UIColor {
        guard frame.height > 0 else { return .Constants.regularPitchfaderStripesColor }
        
        let relativeLocation: CGFloat = closestFaderLocation / frame.height
        let indexOfLastStripeWithDarkerColor = Int(relativeLocation * CGFloat(Int.numberOfVerticalStripes))
        return stripeIndex <= indexOfLastStripeWithDarkerColor ? upperColor : lowerColor
    }
}
private extension Int {
    static let numberOfVerticalStripes = 33
}

