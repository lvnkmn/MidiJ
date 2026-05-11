//
//  UIView+represendedAsView.swift
//  MidiJ
//
//  Created by me on 16/01/2023.
//

import UIKit
import SwiftUI

extension UIView {
    
    var represendedAsView: UIViewRepresenter<UIView> {
        .init {
            self
        }
    }
}
