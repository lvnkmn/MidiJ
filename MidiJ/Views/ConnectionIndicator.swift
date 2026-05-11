//
//  ConnectionIndicator.swift
//  MidiJ
//
//  Created by work on 29/01/2022.
//

import OnionUI

class ConnectionIndicator: StrictlySetupView {

    var isConnected = false {
        didSet {
           setupViewColors()
        }
    }
    
    override func setupViewColors() {
        backgroundColor = isConnected ? .green : .orange
    }
}

extension CGFloat.Constants {
    
    static let connectionIndicatorDiameter: CGFloat = 10
}
