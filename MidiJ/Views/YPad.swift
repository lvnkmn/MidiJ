//
//  YPad.swift
//  MidiJ
//
//  Created by work on 23/01/2022.
//

import OnionUI
import SourceSeeds
import UIKit

class YPad: StrictlySetupView {

    var onYVelocityChanged: ((_ yVelocity: Double)->())?
    
    /// User is holding down on the upper part of the yPad
    var onNudgeByTapUp: (()->())?
    /// User is holding down on the lower part of the yPad
    var onNudgeByTapDown: (()->())?
    /// User did end up holding down on either the upper or lower part of the yPad
    var onEndNudgeByTap: (()->())?
    
    var yVelocity: Double = 0 {
        didSet {
            onYVelocityChanged?(yVelocity)
        }
    }
    
    let topDirectionIndicator = UILabel()
    let bottomDirectionIndicator = UILabel()
    let titleLabel = UILabel()
        .setting(font: .systemFont(ofSize: .Constants.fontSize15, weight: .semibold))
        .setting(textColor: .Constants.primaryTextColor)
    let dotsViews = DotsViews()
    
    private let fingerIndicator = FingerIndicator(frame: .fingerIndicatorFrame)
    
    private let slideGestureRecognizer = UIPanGestureRecognizer()
    private let tapToNudgeRecognizer = UILongPressGestureRecognizer()
    
    private var fingerIndicatorLeadingContraint: NSLayoutConstraint?
    private var fingerIndicatorTopConstraint: NSLayoutConstraint?
    
    override func setupViewColors() {
        topDirectionIndicator.textColor = .Constants.primaryTextColor
        bottomDirectionIndicator.textColor = .Constants.primaryTextColor
        layer.borderColor = UIColor.Constants.darkBorderColor.cgColor
        backgroundColor = .Constants.interactableBackgroundColor
    }
    
    override func setupViewProperties() {
        layer.borderWidth = .Constants.borderWidth2
        layer.cornerRadius = .Constants.cornerRadius16
        clipsToBounds = true
        fingerIndicator.isHidden = true
        addGestureRecognizer(slideGestureRecognizer)
        slideGestureRecognizer.addTarget(self, action: #selector(Self.didSlide(with:)))
        slideGestureRecognizer.delegate = self
        addGestureRecognizer(tapToNudgeRecognizer)
        tapToNudgeRecognizer.addTarget(self, action: #selector(self.didTapToNudge(with:)))
        tapToNudgeRecognizer.minimumPressDuration = 0
        tapToNudgeRecognizer.delegate = self
    }
    
    override func setupViewHierarchy() {
        addSubViews {
            topDirectionIndicator
            bottomDirectionIndicator
            titleLabel
            dotsViews
            fingerIndicator
        }
    }
    
    override func setupViewLayout() {
        topDirectionIndicator.layout.pin(toEdge: .top)?.with(constant: .Constants.spacing02)
        topDirectionIndicator.layout.centerHorizontally()
        
        fingerIndicatorTopConstraint = fingerIndicator.layout.pin(toEdge: .top)
        fingerIndicatorLeadingContraint = fingerIndicator.layout.pin(toEdge: .left)
        
        dotsViews.layout.pin(toEdges: .horizontal)
        dotsViews.layout.below(topDirectionIndicator)
        dotsViews.layout.above(bottomDirectionIndicator)
        
        bottomDirectionIndicator.layout.above(titleLabel).with(constant: -.Constants.spacing02)
        bottomDirectionIndicator.layout.centerHorizontally()
        
        titleLabel.layout.centerHorizontally()
        titleLabel.layout.pin(toEdge: .bottom)?.with(constant: -.Constants.spacing16)
    }
}

extension YPad: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer === tapToNudgeRecognizer && otherGestureRecognizer.state == .began  {
            return false
        }
        
        return true
    }
}

private extension YPad {
    
    @objc func didSlide(with gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began, .changed:
            fingerIndicator.isHidden = false
            let location = gestureRecognizer.location(in: self)
            fingerIndicatorLeadingContraint?.constant = min(max(location.x - .fingerIndicatorSize / 2, 0), frame.width - .fingerIndicatorSize)
            fingerIndicatorTopConstraint?.constant = min(max(location.y - .fingerIndicatorSize / 2, 0), frame.height - .fingerIndicatorSize)
        case .ended, .cancelled:
            fingerIndicator.isHidden = true
        default:
            return
        }
    }
    
    @objc func didTapToNudge(with gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            let halfwaypoint = frame.height / 2
            let location = gestureRecognizer.location(in: self)
            if location.y < halfwaypoint {
                dotsViews.upperDotsView.isHeld = true
                onNudgeByTapUp?()
            } else if location.y > halfwaypoint {
                dotsViews.lowerDotsView.isHeld = true
                onNudgeByTapDown?()
            }
        case .changed:
            // We don't want to mess with an ongoing nudge
            break
        default:
            dotsViews.upperDotsView.isHeld = false
            dotsViews.lowerDotsView.isHeld = false
            onEndNudgeByTap?()
        }
    }
}

private extension CGFloat {
    
    static var fingerIndicatorSize: CGFloat = 40
    static var fingerSlideDetectionThresshold: CGFloat = 30
}

private extension CGRect {
    
    static var fingerIndicatorFrame: CGRect = .init(origin: .zero, size: .init(width: .fingerIndicatorSize, height: .fingerIndicatorSize))
}
