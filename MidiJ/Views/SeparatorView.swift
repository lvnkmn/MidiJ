//
//  SeparatorView.swift
//  MidiJ
//
//  Created by me on 28/11/2022.
//

import OnionUI

class SeparatorView: StrictlySetupView {
    
    override func setupViewColors() {
        backgroundColor = .Constants.listSeparatorColor
    }
    
    override func setupViewLayout() {
        layout.setHeight(to: 1)
    }
}
