//
//  Bounds.swift
//  MidiJ
//
//  Created by work on 21/01/2022.
//

import Foundation

struct Bounds<T: Comparable>  {
    let minValue: T
    let maxValue: T
    
    init?(minValue: T, maxValue: T) {
        guard minValue <= maxValue else { return nil }
        self.minValue = minValue
        self.maxValue = maxValue
    }
}
