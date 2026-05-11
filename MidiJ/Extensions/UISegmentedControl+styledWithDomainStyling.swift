//
//  UISegmentedControl+styledWithDomainStyling.swift
//  MidiJ
//
//  Created by work on 07/02/2022.
//

import UIKit

extension UISegmentedControl {
    
    func styledWithDomainStyling() -> UISegmentedControl {
        setTitleTextAttributes(
            [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: .Constants.fontSize13, weight: .semibold),
                NSAttributedString.Key.foregroundColor : UIColor.Constants.primaryTextColor
            ],
            for: .normal
        )
        
        setTitleTextAttributes(
            [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: .Constants.fontSize13, weight: .semibold),
                NSAttributedString.Key.foregroundColor : UIColor.Constants.highlightedTextColor,
            ],
            for: .selected
        )
        selectedSegmentTintColor = Settings.Repository.shared.settings.tintColor
        
        return self
    }
}
