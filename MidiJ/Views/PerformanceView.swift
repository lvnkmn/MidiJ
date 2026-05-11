//
//  ControllerView.swift
//  MidiJ
//
//  Created by me on 23/12/2022.
//

import OnionUI
import SwiftUI

class PerformanceView: StrictlySetupView {

    let bpmCounterAndIndicator = BPMCounter()
    let nudgeValueButton = BasicButton.tinyButton
    let pitchValueButton = BasicButton.tinyButton
    let cueButton = BigButton()
    let playPauseButton = BigButton()
    let pitchFader = Fader()
    let yPad = YPad()
    
    override func setupViewHierarchy() {
        addSubViews {
            pitchValueButton
            pitchFader
            yPad
            nudgeValueButton
            bpmCounterAndIndicator
            cueButton
            playPauseButton
        }
    }
    
    override func setupViewLayout() {
        layout.activate {
            yPad.topAnchor.constraint(equalTo: topAnchor)
            yPad.topAnchor.constraint(equalTo: pitchFader.topAnchor)
            yPad.leftAnchor.constraint(equalTo: leftAnchor)
            nudgeValueButton.topAnchor.constraint(equalTo: yPad.bottomAnchor, constant: .Constants.spacing10)
            nudgeValueButton.widthAnchor.constraint(equalTo: yPad.widthAnchor)
            nudgeValueButton.leftAnchor.constraint(equalTo: yPad.leftAnchor)
            nudgeValueButton.rightAnchor.constraint(equalTo: yPad.rightAnchor)
            nudgeValueButton.bottomAnchor.constraint(equalTo: playPauseButton.bottomAnchor)
            
            pitchValueButton.topAnchor.constraint(equalTo: pitchFader.bottomAnchor, constant: .Constants.spacing10)
            pitchValueButton.widthAnchor.constraint(equalTo: pitchFader.widthAnchor)
            pitchValueButton.leftAnchor.constraint(equalTo: pitchFader.leftAnchor)
            pitchValueButton.rightAnchor.constraint(equalTo: pitchFader.rightAnchor)
            pitchValueButton.bottomAnchor.constraint(equalTo: nudgeValueButton.bottomAnchor)
            
            pitchFader.rightAnchor.constraint(equalTo: rightAnchor)
            pitchFader.widthAnchor.constraint(equalTo: yPad.widthAnchor)
            nudgeValueButton.centerXAnchor.constraint(equalTo: yPad.centerXAnchor)
            nudgeValueButton.topAnchor.constraint(equalTo: pitchValueButton.topAnchor)
            nudgeValueButton.widthAnchor.constraint(equalTo: yPad.widthAnchor)
            bpmCounterAndIndicator.leftAnchor.constraint(equalTo: yPad.rightAnchor, constant: .Constants.spacing20)
            bpmCounterAndIndicator.rightAnchor.constraint(equalTo: pitchFader.leftAnchor, constant: -.Constants.spacing20)
            bpmCounterAndIndicator.bottomAnchor.constraint(equalTo: cueButton.topAnchor, constant: -.Constants.spacing16)
            cueButton.heightAnchor.constraint(equalTo: cueButton.widthAnchor)
            cueButton.bottomAnchor.constraint(equalTo: playPauseButton.topAnchor, constant: -.Constants.spacing16)
            cueButton.leftAnchor.constraint(equalTo: yPad.rightAnchor, constant: .Constants.spacing20)
            cueButton.rightAnchor.constraint(equalTo: pitchFader.leftAnchor, constant: -.Constants.spacing20)
            playPauseButton.heightAnchor.constraint(equalTo: playPauseButton.widthAnchor)
            playPauseButton.leftAnchor.constraint(equalTo: yPad.rightAnchor, constant: .Constants.spacing20)
            playPauseButton.rightAnchor.constraint(equalTo: pitchFader.leftAnchor, constant: -.Constants.spacing16)
            playPauseButton.bottomAnchor.constraint(equalTo: bottomAnchor)
            playPauseButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4)
        }

        bpmCounterAndIndicator.layout.pin(toEdge: .top, of: yPad)
    }
    
    override func setupViewColors() {
        backgroundColor = .Constants.backgroundColor
    }
}

struct PerformanceView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PerformanceView().represendedAsView
        }
    }
}
