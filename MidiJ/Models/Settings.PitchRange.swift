//
//  Settings.PitchRange.swift
//  MidiJ
//
//  Created by work on 30/01/2022.
//

import Foundation

extension Settings {
    
    enum PitchRange: Int, CaseIterable, Codable {
        case plusMinus006
        case plusMinus010
        case plusMinus016
        case plusMinus100
    }
}

extension Settings.PitchRange {
    
    var localizedDescription: String {
        switch self {
        case .plusMinus006:
            return "± 6%"
        case .plusMinus010:
            return "± 10%"
        case .plusMinus016:
            return "± 16%"
        case .plusMinus100:
            return "± 100%"
        }
    }
    
    var multiplier: Double {
        switch self {
        case .plusMinus006:
            return 6
        case .plusMinus010:
            return 10
        case .plusMinus016:
            return 16
        case .plusMinus100:
            return 100
        }
    }
}
