//
//  UIViewPropertyAnimator+layoutAnimator.swift
//  MidiJ
//
//  Created by me on 12/02/2023.
//

import UIKit

extension UIViewPropertyAnimator {
    static var layoutAnimator: UIViewPropertyAnimator {
        .init(duration: 0.2, curve: .easeInOut)
    }
}
