//
//  TempoRangeViewController.swift
//  MidiJ
//
//  Created by work on 30/01/2022.
//

import OnionUI
import SourceSeeds
import UIKit

class PitchRangeViewController: UIViewController {

    private let pitchRangeHeaderLabel = UILabel.styled
        .setting(text: "Tempo Range")
    
    private let pitchRangeSegmentedControl = UISegmentedControl().styledWithDomainStyling()
    
    private let faderDirectionHeaderLabel = UILabel.styled
        .setting(text: "Fader Direction")
    
    private let faderDirectionSegmentedControl = UISegmentedControl().styledWithDomainStyling()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
}

extension PitchRangeViewController: SettingUpViews {
    
    func setupViewColors() {
        view.backgroundColor = .Constants.settingsViewBackground
    }
    
    func setupViewProperties() {
        faderDirectionSegmentedControl.addTarget(self, action: #selector(didSelectPitchDirection), for: .valueChanged)
        pitchRangeSegmentedControl.addTarget(self, action: #selector(didSelectPitchRange), for: .valueChanged)
        pitchRangeSegmentedControl.removeAllSegments()
        for (index, pitchRange) in Settings.PitchRange.allCases.enumerated() {
            pitchRangeSegmentedControl.insertSegment(withTitle: pitchRange.localizedDescription, at: index, animated: false)
        }
        pitchRangeSegmentedControl.selectedSegmentIndex = Settings.Repository.shared.settings.pitchRange.rawValue
        
        faderDirectionSegmentedControl.removeAllSegments()
        for (index, direction) in Settings.VerticalMovement.allCases.enumerated() {
            faderDirectionSegmentedControl.insertSegment(withTitle: direction.localizedDescription, at: index, animated: false)
        }
        faderDirectionSegmentedControl.selectedSegmentIndex = Settings.Repository.shared.settings.pitchFaderDirection.rawValue
    }
    
    func setupViewHierarchy() {
        view.addSubViews {
            pitchRangeHeaderLabel
            pitchRangeSegmentedControl
            faderDirectionHeaderLabel
            faderDirectionSegmentedControl
        }
    }
    
    func setupViewLayout() {
        view.layoutMargins = .Constants.popoverMargin
        
        pitchRangeHeaderLabel.layout.pin(toEdges: .topLeft, shouldConsiderMargin: true)
        
        pitchRangeSegmentedControl.layout.below(pitchRangeHeaderLabel).with(constant: .Constants.spacing08)
        pitchRangeSegmentedControl.layout.pin(toEdges: .horizontal, shouldConsiderMargin: true)
        
        faderDirectionHeaderLabel.layout.below(pitchRangeSegmentedControl).with(constant: .Constants.spacing08)
        faderDirectionHeaderLabel.layout.pin(toEdge: .left, shouldConsiderMargin: true)
        
        faderDirectionSegmentedControl.layout.below(faderDirectionHeaderLabel).with(constant: .Constants.spacing08)
        faderDirectionSegmentedControl.layout.pin(toEdges: .horizontal, shouldConsiderMargin: true)
        faderDirectionSegmentedControl.layout.pin(toEdge: .bottom, constant: -.Constants.popOverIndicatorPadding, shouldConsiderMargin: true)
    }
}

private extension PitchRangeViewController {
    
    @objc func didSelectPitchRange() {
        Settings.Repository.shared.changeSettings {
            $0.pitchRange = .init(rawValue: pitchRangeSegmentedControl.selectedSegmentIndex) ?? .plusMinus010
        }
    }
    
    @objc func didSelectPitchDirection() {
        Settings.Repository.shared.changeSettings {
            $0.pitchFaderDirection = .init(rawValue: faderDirectionSegmentedControl.selectedSegmentIndex) ?? .downToSpeedUp
        }
    }
}
