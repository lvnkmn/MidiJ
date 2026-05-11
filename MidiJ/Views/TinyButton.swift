//
//  TinyButton.swift
//  MidiJ
//
//  Created by me on 25/07/2022.
//

import OnionUI
import UIKit

class BasicButton: Control {

    let textLabel = UILabel()
        .setting(font: .systemFont(ofSize: .Constants.fontSize15, weight: .semibold))
        .setting(textColor: .Constants.primaryTextColor)

    override func setupViewHierarchy() {
        addSubview(textLabel)
    }

    override func setupViewLayout() {
        textLabel.layout.center()
    }
}

extension BasicButton {
    
    static var tinyButton: BasicButton {
        BasicButton()
            .setting(backgroundColor: .Constants.interactableBackgroundColor)
            .setting(layerBorderColor: UIColor.Constants.darkBorderColor)
            .setting(layerBorderWidth: .Constants.borderWidth2)
            .setting(layerCornerRadius: .Constants.cornerRadius16)
            .layedOutWith { layout in
                layout.setHeight(to: .Constants.tinyButtonHeight)
            }
    }
}
