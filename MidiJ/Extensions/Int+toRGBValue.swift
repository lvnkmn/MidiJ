//
//  Int+toRGBValue.swift
//  MidiJ
//
//  Created by me on 12/12/2022.
//

import Foundation

extension Int {
    
    var toRGBValue: CGFloat {
        CGFloat(self) / CGFloat(255)
    }
}
