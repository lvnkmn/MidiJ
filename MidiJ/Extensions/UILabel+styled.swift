//
//  StyledLabel.swift
//  MidiJ
//
//  Created by work on 30/01/2022.
//

import OnionUI
import UIKit

extension UILabel {
    
    static var styled: UILabel {
        UILabel()
            .setting(textColor: .Constants.primaryTextColor)
            .setting(font: .systemFont(ofSize: .Constants.fontSize20, weight: .regular))
    }
}
