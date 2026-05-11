//
//  YPad.DotsViews.swift
//  MidiJ
//
//  Created by me on 01/08/2022.
//

import OnionUI
import UIKit

extension YPad {
    
    class DotsViews: StrictlySetupView {
        
        let upperDotsView = DotsView()
        let dotsViewsSeparator = UIView()
        let lowerDotsView = DotsView()
        
        var childViews: [UIView] {
            [
                upperDotsView,
                dotsViewsSeparator,
                lowerDotsView
            ]
        }
        
        override func setupViewProperties() {
            dotsViewsSeparator.backgroundColor = .Constants.darkBorderColor
        }
        
        override func setupViewHierarchy() {
            childViews.forEach(addSubview)
        }
        
        override func setupViewLayout() {
            upperDotsView.layout.pin(toEdges: .all.except(.bottom))
            
            dotsViewsSeparator.layout.below(upperDotsView)
            dotsViewsSeparator.layout.pin(toEdges: .horizontal)
            dotsViewsSeparator.layout.setHeight(to: .Constants.borderWidth2)
            
            lowerDotsView.layout.below(dotsViewsSeparator)
            lowerDotsView.layout.pin(toEdges: .all.except(.top))
            
            lowerDotsView.heightAnchor.constraint(equalTo: upperDotsView.heightAnchor).activated()
        }
    }
}
