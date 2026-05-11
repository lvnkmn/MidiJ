//
//  String.formattedBPM.swift
//  MidiJ
//
//  Created by me on 12/12/2022.
//

import Foundation

extension String {
    
    static func formatted(bpm: Double) -> String? {
        Shared.bpmFormatter.string(from: .init(floatLiteral: bpm))
            .map {
                $0 + " BPM"
            }
    }
}
