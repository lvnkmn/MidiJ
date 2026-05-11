//
//  UIColor.Components.swift
//  MidiJ
//
//  Created by me on 12/12/2022.
//

import UIKit

extension UIColor {
    
    struct Components: Codable {
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        let alpha: CGFloat
    }
    
    var components: UIColor.Components {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return .init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
