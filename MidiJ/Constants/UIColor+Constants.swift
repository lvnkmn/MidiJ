//
//  UIColor+Constants.swift
//  MidiJ
//
//  Created by work on 30/01/2022.
//

import Foundation
import UIKit

extension UIColor {
    
    struct Constants {
        static var backgroundColor: UIColor = .init(white: 16.toRGBValue, alpha: 1)
        static let faderCapColor: UIColor = .white
        static let primaryTextColor: UIColor = .white
        static let secondaryTextColor: UIColor = .white.withAlphaComponent(0.6)
        static let highlightedTextColor: UIColor = .black
        static let darkBorderColor: UIColor = .black
        static let listSeparatorColor: UIColor = .white.withAlphaComponent(0.12)
        static let lightBorderColor: UIColor = .white
        static let pressedStateColor: UIColor = .white
        static let highlightedPitchfaderStripesColor: UIColor = .white
        
        static var bpmPulseColor: UIColor {
            Settings.Repository.shared.settings.tintColor.withAlphaComponent(0.6)
        }
        
        static let settingsViewBackground: UIColor = .init(
            red: 28.toRGBValue,
            green: 28.toRGBValue,
            blue: 30.toRGBValue,
            alpha: 1
        )
        
        static let interactableBackgroundColor: UIColor = .white
            .withAlphaComponent(0.04)
            .opaqueColor(consideringBackgroundColor: .Constants.backgroundColor)
        
        
        static let regularPitchfaderStripesColor: UIColor = .white
            .withAlphaComponent(0.2)
            .opaqueColor(consideringBackgroundColor: .Constants.interactableBackgroundColor)
        
        static let yPadDotColors = HighLightableColor(
            normal: .white
                .withAlphaComponent(0.2)
                .opaqueColor(consideringBackgroundColor: .Constants.interactableBackgroundColor),
            highLighted: .white
                .withAlphaComponent(0.8)
                .opaqueColor(consideringBackgroundColor: .Constants.interactableBackgroundColor)
        )
    }
}

extension UIColor {
    
    func opaqueColor(consideringBackgroundColor backgroundColor: UIColor) -> UIColor {
        let foregroundRGBA = components
        let backgroundRGBA = backgroundColor.components
        
        return .init(
            red: .opaqueColorComponent(
                consideringForegroundComponent: foregroundRGBA.red,
                backgroundComponent: backgroundRGBA.red,
                andForeGroundAlpha: foregroundRGBA.alpha
            ),
            green: .opaqueColorComponent(
                consideringForegroundComponent: foregroundRGBA.green,
                backgroundComponent: backgroundRGBA.green,
                andForeGroundAlpha: foregroundRGBA.alpha
            ),
            blue: .opaqueColorComponent(
                consideringForegroundComponent: foregroundRGBA.blue,
                backgroundComponent: backgroundRGBA.blue,
                andForeGroundAlpha: foregroundRGBA.alpha
            ),
            alpha: 1
        )
    }
}

extension UIColor {
    
    struct HighLightableColor {
        
        let normal: UIColor
        let highLighted: UIColor
        
        func forState(isHighlighted: Bool) -> UIColor {
            isHighlighted ? highLighted : normal
        }
    }
}

private extension CGFloat {
    /// Taken from
    /// https://hangzone.com/calculate-implied-rgb-color-opacity-changes/
    static func opaqueColorComponent(
        consideringForegroundComponent foregroundComponent: CGFloat,
        backgroundComponent: CGFloat,
        andForeGroundAlpha foreGroundAlpha: CGFloat
    ) -> CGFloat {
        foreGroundAlpha * foregroundComponent + (1 - foreGroundAlpha) * backgroundComponent
    }
}
