//
//  Settings.swift
//  MidiJ
//
//  Created by work on 30/01/2022.
//

import Foundation
import UIKit

struct Settings: Codable {
    var pitchRange = PitchRange.plusMinus010
    var nudgeDirection = VerticalMovement.upToSpeedUp
    var pitchFaderDirection = VerticalMovement.downToSpeedUp
    var nudgeSensitivity: NudgeSensitivity = .plusMinus005
    var connectionType = ConnectionType.midi
    var enableHapticFeedback = true
    var showOnBoardingUponNextLaunch = true
    var showPitchFaderCap = true
    
    var tintColor: UIColor {
        get {
            .init(red: tintColorComponents.red, green: tintColorComponents.green, blue: tintColorComponents.blue, alpha: tintColorComponents.alpha)
        }
        
        set {
            tintColorComponents = newValue.components
        }
    }
    
    private var tintColorComponents = UIColor.Components(
        red: 196.toRGBValue,
        green: 163.toRGBValue,
        blue: 253.toRGBValue,
        alpha: 1
    )
}

extension Settings: CustomStringConvertible {
    var description: String {
        """
        pitchRange =  \(pitchRange)
        nudgeDirection = \(nudgeDirection)
        pitchFaderDirection = \(pitchFaderDirection)
        nudgeSensitivity = \(nudgeSensitivity)
        connectionType = \(connectionType)
        enableHapticFeedback = \(enableHapticFeedback)
        showOnBoardingUponNextLaunch = \(showOnBoardingUponNextLaunch)
        showPitchFaderCap = \(showPitchFaderCap)
        """
    }
}
