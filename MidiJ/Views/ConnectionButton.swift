//
//  ConnectionButton.swift
//  MidiJ
//
//  Created by work on 29/01/2022.
//

import SwiftUI
import OnionUI

class ConnectionButton: Control {
    
    let textLabel = UILabel()
        .setting(font: .systemFont(ofSize: .Constants.fontSize15, weight: .semibold))
    
    let connectionIndicator = ConnectionIndicator()
        .setting(layerCornerRadius: .Constants.connectionIndicatorDiameter / 2)
        .layedOutWith { layout in
            layout.setWidth(to: .Constants.connectionIndicatorDiameter)
            layout.setAspectRatio(to: 1)
        }
        
    override func setupViewHierarchy() {
        addPinnedSubView {
            UIStackView()
                .horizontalize()
                .setting(allignment: .center)
                .setting(spacing: .Constants.spacing11)
                .addArrangedSubViews {
                    textLabel
                    connectionIndicator
                }
        }
    }
}

struct ConnectionButton_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionButton().mutated {
            $0.textLabel.text = "MIDI"
        }
        .represendedAsView
    }
}
