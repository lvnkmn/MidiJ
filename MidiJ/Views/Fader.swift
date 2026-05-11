//
//  Fader.swift
//  MidiJ
//
//  Created by work on 21/01/2022.
//

import OnionUI
import SourceSeeds
import UIKit

class Fader: StrictlySetupView {

    var onValueChanged: ((_ value: Double) -> ())?
    
    /// Value between 0 and 1
    var value: Double = 0 {
        didSet {
            onValueChanged?(value)
            matchFaderCapPositionWithValue()
        }
    }
    
    let topDirectionIndicator = UILabel()
        .setting(textColor: .Constants.primaryTextColor)
    
    let bottomDirectionIndicator = UILabel()
        .setting(textColor: .Constants.primaryTextColor)
    
    let stripesView = StripesView()
    
    let titleLabel = UILabel()
        .setting(textColor: .Constants.primaryTextColor)
        .setting(font: .systemFont(ofSize: .Constants.fontSize15, weight: .semibold))
    
    private let faderCap = UIView()
        .setting(backgroundColor: .faderCapColorConsideringSettings())
        .setting(layerCornerRadius: .Constants.globalCorderRadius)
    
    /// We put the fadercap  in a container so that it's pan gesture is more easily recognized
    private let faderCapContainer = UIView()
    //If we draw borders on `Fader` their always appear ontop of the fadercap, we don't want this
    private let borderView = UIView()
        .setting(layerCornerRadius: .Constants.cornerRadius16)
        .setting(layerBorderWidth: .Constants.borderWidth2)
        .setting(layerBorderColor: .Constants.darkBorderColor)
        .setting(backgroundColor: .Constants.interactableBackgroundColor)
        .setting(clipsToBounds: true)

    private let slideGestureRecognizer = UIPanGestureRecognizer()
    private let fineTuneGestureRecognizer = UIPanGestureRecognizer()
    private let tripleTapFaderCapRecognizer = UITapGestureRecognizer()
        .mutated {
            $0.numberOfTapsRequired = 3
        }
    
    private var faderCapYPositionConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(forName: .midiJsettingsDidChange, object: nil, queue: .main) { _ in
            self.faderCap.backgroundColor = .faderCapColorConsideringSettings()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        value = 0.5
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        matchFaderCapPositionWithValue()
    }
    
    override func setupViewProperties() {
        slideGestureRecognizer.addTarget(self, action: #selector(didRecognizeSlide(with:)))
        fineTuneGestureRecognizer.addTarget(self, action: #selector(didRecognizeFinetune(with:)))
        tripleTapFaderCapRecognizer.addTarget(self, action: #selector(didTripleTapFaderCap))
        faderCapContainer.addGestureRecognizer(slideGestureRecognizer)
        faderCapContainer.addGestureRecognizer(tripleTapFaderCapRecognizer)
        addGestureRecognizer(fineTuneGestureRecognizer)
    }
    
    override func setupViewHierarchy() {
        addSubViews {
            borderView
            titleLabel
            stripesView
            topDirectionIndicator
            bottomDirectionIndicator
            faderCapContainer
                .addSubViews {
                    faderCap
                }
        }
    }
    
    override func setupViewLayout() {
        faderCapYPositionConstraint = faderCapContainer.layout.centerVertically()
        
        layout.activate {
            borderView.leftAnchor.constraint(equalTo: leftAnchor)
            borderView.topAnchor.constraint(equalTo: topAnchor)
            borderView.rightAnchor.constraint(equalTo: rightAnchor)
            borderView.bottomAnchor.constraint(equalTo: bottomAnchor)
            faderCap.leftAnchor.constraint(equalTo: faderCapContainer.leftAnchor)
            faderCap.rightAnchor.constraint(equalTo: faderCapContainer.rightAnchor)
            faderCap.heightAnchor.constraint(equalToConstant: .Constants.faderCapHeight)
            faderCap.centerYAnchor.constraint(equalTo: faderCapContainer.centerYAnchor)
            faderCap.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: .Constants.faderCapOffsetFromTopAndBottom)
            faderCap.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -.Constants.faderCapOffsetFromTopAndBottom)
            faderCapContainer.heightAnchor.constraint(equalToConstant: .Constants.faderCapContainerHeight)
            faderCapContainer.leftAnchor.constraint(equalTo: leftAnchor)
            faderCapContainer.rightAnchor.constraint(equalTo: rightAnchor)
            topDirectionIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
            topDirectionIndicator.topAnchor.constraint(equalTo: topAnchor, constant: .Constants.spacing02)
            bottomDirectionIndicator.bottomAnchor.constraint(
                equalTo: titleLabel.topAnchor,
                constant: -.Constants.spacing02
            )
            bottomDirectionIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.Constants.spacing16)
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            stripesView.leftAnchor.constraint(equalTo: leftAnchor, constant: .Constants.spacing10)
            stripesView.rightAnchor.constraint(equalTo: rightAnchor, constant: -.Constants.spacing10)
            stripesView.topAnchor.constraint(equalTo: topDirectionIndicator.bottomAnchor)
            stripesView.bottomAnchor.constraint(equalTo: bottomDirectionIndicator.topAnchor)
        }
    }
}

extension Fader {
    
    func matchFaderCapPositionWithValue() {
        faderCapYPositionConstraint = faderCapYPositionConstraint?.with(
            multiplier: .faderMulitplier(basedOnFaderValue: value)
        )

        stripesView.closestFaderLocation = .faderYPosition(inStripesView: stripesView, faderValue: value)
    }
}

private extension Fader {
    
    @objc func didRecognizeSlide(with recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            let yLocation = recognizer.location(in: self).y
            value = value(fromYLocation: yLocation - .Constants.faderCapHeight / 2)
        default:
            return
        }
    }
    
    @objc func didRecognizeFinetune(with recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            let velocity: CGFloat = recognizer.velocity(in: self).y
            var nonFinalValue = value
            let delta = pow(velocity * 0.00005, 2) * 0.3
            if velocity >= 1 {
                nonFinalValue += delta
            } else {
                nonFinalValue -= delta
            }
            value = min(max(0, nonFinalValue), 1)
            
        default:
            return
        }
    }
    
    @objc func didTripleTapFaderCap() {
        reset()
    }
    
    func value(fromYLocation yLocation: CGFloat) -> Double {
        let slideHeight = frame.height - .Constants.faderCapHeight
        let multiplier = max(min(yLocation, slideHeight), 0) / slideHeight
        
        return Double(multiplier)
    }
    
    func yPositionConstant(from value: CGFloat) -> CGFloat {
        let spacingAboveAndBelowFaderCap: CGFloat = .Constants.faderCapContainerHeight - .Constants.faderCapHeight
        let spacingAboveOrBelowFaderCap = spacingAboveAndBelowFaderCap / 2
        let lowestValue: CGFloat = -spacingAboveOrBelowFaderCap
        let highestValue = frame.height - .Constants.faderCapContainerHeight + spacingAboveOrBelowFaderCap
        let range = highestValue - lowestValue
        return value * range + lowestValue
    }
}

private extension CGFloat.Constants {
    
    static let faderCapHeight: CGFloat = 30
    static let faderCapContainerHeight: CGFloat = 100
    static let faderCapOffsetFromTopAndBottom: CGFloat = (faderCapHeight / 2) - 10
}

private extension CGFloat {
    
    static func faderMulitplier(basedOnFaderValue faderValue: CGFloat) -> CGFloat {
        Swift.max(
            Swift.min(
                faderValue * 2,
                2
            ),
            0.0001 //Can't be 0 since autolayout otherwise crashes. Luckily this isn't noticible
        )
    }
    
    static func faderYPosition(inStripesView stripesView: Fader.StripesView, faderValue: CGFloat) -> CGFloat {
        stripesView.superview.map { stripesViewContainer in
            Swift.min(Swift.max(stripesView.convert(.init(x: 0, y: faderValue * stripesViewContainer.frame.height), from: stripesViewContainer).y, 0), stripesView.frame.height)
        } ?? .zero
    }
}

private extension UIColor {
    
    static func faderCapColorConsideringSettings() -> UIColor {
        Settings.Repository.shared.settings.showPitchFaderCap ? .Constants.faderCapColor : .clear
    }
}
