//
//  Settings.NudgeDirection.swift
//  MidiJ
//
//  Created by work on 01/02/2022.
//

import Foundation

extension Settings {
    
    enum VerticalMovement: Int, CaseIterable, Codable {
        case upToSpeedUp
        case downToSpeedUp
    }
}

extension Settings.VerticalMovement {
    
    var localizedDescription: String {
        switch self {
        case .upToSpeedUp:
            return "Up is faster"
        case .downToSpeedUp:
            return "Down is faster"
        }
    }
    
    var multiplier: Double {
        switch self {
        case .upToSpeedUp:
            return 1
        case .downToSpeedUp:
            return -1
        }
    }
}
