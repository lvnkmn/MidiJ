//
//  UISegmentedControl+styledWithDomainStyling.swift
//  MidiJ
//
//  Created by work on 07/02/2022.
//

import UIKit

extension UISlider {
    
    func styledWithDomainStyling() -> UISlider {
        tintColor = Settings.Repository.shared.settings.tintColor
        
        return self
    }
}
