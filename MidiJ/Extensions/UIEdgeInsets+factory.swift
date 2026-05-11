//
//  UIEdgeInsets+factory.swift
//  MidiJ
//
//  Created by me on 16/01/2023.
//

import Foundation
import UIKit

extension UIEdgeInsets {
    
    struct Horizontal {
        let left: CGFloat
        let right: CGFloat
        
        static var zero: Horizontal = .init(left: .zero, right: .zero)
    }
    
    struct Vertical {
        let top: CGFloat
        let bottom: CGFloat
        
        static var zero: Vertical = .init(top: .zero, bottom: .zero)
    }
    
    static func make(horizontal: CGFloat = .zero, vertical: CGFloat = .zero) -> UIEdgeInsets {
        .init(
            top: vertical,
            left: horizontal,
            bottom: -vertical,
            right: -horizontal
        )
    }
    
    static func make(horizontal: Horizontal = .zero, vertical: Vertical = .zero) -> UIEdgeInsets {
        .init(
            top: vertical.top,
            left: horizontal.left,
            bottom: -vertical.bottom,
            right: -horizontal.right
        )
    }
    
    static func make(all: CGFloat) -> UIEdgeInsets {
        .init(top: all, left: all, bottom: -all, right: -all)
    }
}
