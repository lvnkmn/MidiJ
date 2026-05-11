//
//  Settings.ConnectionType.swift
//  MidiJ
//
//  Created by me on 01/03/2022.
//

import Foundation
import UIKit

extension Settings {
    
    enum ConnectionType: Int, Codable, CaseIterable {
        case midi
    }
}

extension Settings.ConnectionType {
    
    var localizedDescription: String {
        switch self {
        case .midi:
            return .Copy.ConnectionType.midi
        }
    }
}
