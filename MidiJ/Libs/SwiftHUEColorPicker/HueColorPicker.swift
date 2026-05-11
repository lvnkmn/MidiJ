//
//  SwiftHUEColorPicker.swift
//  SwiftHUEColorPicker
//
//  Created by Maxim Bilan on 5/6/15.
//  Copyright (c) 2015 Maxim Bilan. All rights reserved.
//

import UIKit

public protocol HueColorPickerDelegate : AnyObject {
    func valuePicked(_ color: UIColor, type: HueColorPicker.PickerType)
}

open class HueColorPicker: UIView {
    
    // MARK: - Type
    
    public enum PickerType: Int {
        case color
        case saturation
        case brightness
        case alpha
    }
    
    // MARK: - Constants
    
    let HUEMaxValue: CGFloat = 360
    let PercentMaxValue: CGFloat = 100
    
    // MARK: - Main public properties
    
    open weak var delegate: HueColorPickerDelegate!
    open var type: PickerType = .color
    open var currentColor: UIColor {
        get {
            return color
        }
        set(newCurrentColor) {
            color = newCurrentColor
            var hue: CGFloat = 0
            var s: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            if color.getHue(&hue, saturation: &s, brightness: &b, alpha: &a) {
                var needUpdate = false
                if hueValue != hue {
                    needUpdate = true
                }
                
                hueValue = hue
                saturationValue = s
                brightnessValue = b
                alphaValue = a
                
                if needUpdate && hueValue > 0 && hueValue < 1 {
                    update()
                    setNeedsDisplay()
                }
            }
        }
    }
    
    // MARK: - Additional public properties
    
    open var labelFontColor: UIColor = UIColor.white
    open var labelBackgroundColor: UIColor = UIColor.black
    open var labelFont = UIFont(name: "Helvetica Neue", size: 12)
    open var cornerRadius: CGFloat = 10.0
    
    // MARK: - Private properties
    
    fileprivate var color: UIColor = UIColor.clear
    fileprivate var currentSelectionY: CGFloat = 0.0
    fileprivate var currentSelectionX: CGFloat = 0.0
    fileprivate var hueImage: UIImage!
    fileprivate var hueValue: CGFloat = 0.0
    fileprivate var saturationValue: CGFloat = 1.0
    fileprivate var brightnessValue: CGFloat = 1.0
    fileprivate var alphaValue: CGFloat = 1.0
    
    // MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        update()
    }
    
    // MARK: - Prerendering
    
    func generateHUEImage(_ size: CGSize) -> UIImage? {
        guard size.width > 0 else { return nil }
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        
        for x: Int in 0 ..< Int(size.width) {
            
            switch type {
            case .color:
                UIColor(
                    hue: .hsbValue(
                        forXCoordinate: CGFloat(x),
                        consideringWidth: size.width,
                        andFingerIndicatorSize: size.height
                    ),
                    saturation: saturationValue,
                    brightness: brightnessValue,
                    alpha: alphaValue
                ).set()
                break
            case .saturation:
                UIColor(
                    hue: hueValue,
                    saturation: .hsbValue(
                        forXCoordinate: CGFloat(x),
                        consideringWidth: size.width,
                        andFingerIndicatorSize: size.height
                    ),
                    brightness: 1.0,
                    alpha: 1.0
                ).set()
                break
            case .brightness:
                UIColor(
                    hue: hueValue,
                    saturation: 1.0,
                    brightness: .hsbValue(
                        forXCoordinate: CGFloat(x),
                        consideringWidth: size.width,
                        andFingerIndicatorSize: size.height
                    ),
                    alpha: 1.0
                ).set()
                break
            case .alpha:
                UIColor(
                    hue: hueValue,
                    saturation: 1.0,
                    brightness: 1.0,
                    alpha: .hsbValue(
                        forXCoordinate: CGFloat(x),
                        consideringWidth: size.width,
                        andFingerIndicatorSize: size.height
                    )
                ).set()
                break
            }
            
            let temp = CGRect(x: CGFloat(x), y: 0, width: 1, height: size.height)
            UIRectFill(temp)
        }
        
        defer {
            UIGraphicsEndImageContext()
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    // MARK: - Updating
    
    func update() {
        let offset = frame.size.height
        let halfOffset = offset * 0.5
        var size = self.frame.size
        size.width -= offset
        
        var value: CGFloat = 0
        switch type {
        case .color:
            value = hueValue
            break
        case .saturation:
            value = saturationValue
            break
        case .brightness:
            value = brightnessValue
            break
        case .alpha:
            value = alphaValue
            break
        }
        
        currentSelectionX = (value * size.width) + halfOffset
        currentSelectionY = (value * size.height) + halfOffset
        
        hueImage = generateHUEImage(size)
    }
    
    // MARK: - Drawing
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let circleDiameter = frame.size.height - .Constants.circleStrokeWidth
        let halfRadius = circleDiameter * 0.5
        var circleX = currentSelectionX - halfRadius
        if circleX >= rect.size.width - circleDiameter {
            circleX = rect.size.width - circleDiameter
        }
        else if circleX < 0 {
            circleX = 0
        }
        
        let circleRect = CGRect(x: circleX, y: (.Constants.circleStrokeWidth / 2), width: circleDiameter, height: circleDiameter)
        let circleColor = labelBackgroundColor
        
        if hueImage != nil {
            hueImage.draw(in: rect)
        }
        
        let context = UIGraphicsGetCurrentContext()
        circleColor.set()
        context?.addEllipse(in: circleRect)
        context?.setLineWidth(.Constants.circleStrokeWidth)
        context?.setFillColor(circleColor.cgColor)
        context?.strokePath()
    }
    
    // MARK: - Touch events
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        if let point = touch?.location(in: self) {
            handleTouch(point)
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        if let point = touch?.location(in: self) {
            handleTouch(point)
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        if let point = touch?.location(in: self) {
            handleTouch(point)
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    // MARK: - Touch handling
    
    func handleTouch(_ touchPoint: CGPoint) {
        currentSelectionX = touchPoint.x
        currentSelectionY = touchPoint.y
        
        let offset = frame.size.height
        let halfOffset = offset * 0.5
        if currentSelectionX < halfOffset {
            currentSelectionX = halfOffset
        }
        else if currentSelectionX >= self.frame.size.width - halfOffset {
            currentSelectionX = self.frame.size.width - halfOffset
        }
        if currentSelectionY < halfOffset {
            currentSelectionY = halfOffset
        }
        else if currentSelectionY >= self.frame.size.height - halfOffset {
            currentSelectionY = self.frame.size.height - halfOffset
        }
        
        let value = CGFloat((currentSelectionX - halfOffset) / (self.frame.size.width - offset))
        
        switch type {
        case .color:
            hueValue = value
            break
        case .saturation:
            saturationValue = value
            break
        case .brightness:
            brightnessValue = value
            break
        case .alpha:
            alphaValue = value
            break
        }
        
        color = UIColor(hue: hueValue, saturation: saturationValue, brightness: brightnessValue, alpha: alphaValue)
        
        if delegate != nil {
            delegate.valuePicked(color, type: type)
        }
        
        setNeedsDisplay()
    }
    
}

private extension CGFloat {
    
    static func hsbValue(forXCoordinate xCoordinate: CGFloat, consideringWidth width: CGFloat, andFingerIndicatorSize fingerIndicatorDiameter: CGFloat) -> CGFloat {
        let fingerIndicatorRadius = fingerIndicatorDiameter / 2
        let variableColorsWidth = width - fingerIndicatorDiameter
        return Swift.min(Swift.max(0, xCoordinate - fingerIndicatorRadius) / variableColorsWidth, 1)
    }
}

private extension CGFloat.Constants {
    
    static let circleStrokeWidth = borderWidth2
}
