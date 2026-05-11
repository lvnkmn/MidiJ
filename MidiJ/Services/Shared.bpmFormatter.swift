//
//  Shared.bpmFormatter.swift
//  MidiJ
//
//  Created by me on 12/12/2022.
//

import Foundation

enum Shared {
    
    static let bpmFormatter = NumberFormatter().mutated {
        $0.locale = .current
        $0.minimumFractionDigits = 2
    }
}
