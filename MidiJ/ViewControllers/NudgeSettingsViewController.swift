//
//  NudgeSettingsViewController.swift
//  MidiJ
//
//  Created by work on 07/02/2022.
//

import OnionUI
import SourceSeeds
import UIKit

class NudgeSettingsViewController: UIViewController {

    private let nudgeDirectionHeaderLabel = UILabel.styled
        .setting(text: "Nudge Direction")
    
    private let nudgeDirectionSegmentedControl = UISegmentedControl().styledWithDomainStyling()
    private let nudgeSensitivityHeaderLabel = UILabel.styled
        .setting(text: "Nudge Sensitivity")
    private let nudgeSensitivitySegmentedControl = UISegmentedControl().styledWithDomainStyling()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
}

extension NudgeSettingsViewController: SettingUpViews {
    
    func setupViewColors() {
        view.backgroundColor = .Constants.settingsViewBackground
    }
    
    func setupViewProperties() {
        nudgeDirectionSegmentedControl.addTarget(self, action: #selector(didChangeNudgeDirection), for: .valueChanged)
        nudgeSensitivitySegmentedControl.addTarget(self, action: #selector(didChangeNudgeSensitivity), for: .valueChanged)
       
        nudgeDirectionSegmentedControl.removeAllSegments()
        for (index, nudgeDirection) in Settings.VerticalMovement.allCases.enumerated() {
            nudgeDirectionSegmentedControl.insertSegment(withTitle: nudgeDirection.localizedDescription, at: index, animated: false)
        }
        nudgeDirectionSegmentedControl.selectedSegmentIndex = Settings.Repository.shared.settings.nudgeDirection.rawValue
        
        for (index, nudgeDirection) in Settings.NudgeSensitivity.allCases.enumerated() {
            nudgeSensitivitySegmentedControl.insertSegment(withTitle: nudgeDirection.localizedDescription, at: index, animated: false)
        }
        nudgeSensitivitySegmentedControl.selectedSegmentIndex = Settings.Repository.shared.settings.nudgeSensitivity.rawValue
    }
    
    func setupViewHierarchy() {
        view.addPinnedSubView(withPadding:
                .init(
                    top: .Constants.spacing16,
                    left: .Constants.spacing16,
                    bottom: -.Constants.popOverIndicatorPadding,
                    right: -.Constants.spacing16
                )
        ) {
            UIStackView()
                .verticalize()
                .setting(allignment: .leading)
                .setting(spacing: .Constants.spacing08)
                .addArrangedSubViews {
                    nudgeDirectionHeaderLabel
                    nudgeDirectionSegmentedControl
                    nudgeSensitivityHeaderLabel
                    nudgeSensitivitySegmentedControl
                }
                .mutated { it in
                    it.setCustomSpacing(.Constants.spacing16, after: nudgeDirectionSegmentedControl)
                }
        }
    }
    
    func setupViewLayout() {
        view.layoutMargins = .Constants.popoverMargin
    }
}

private extension NudgeSettingsViewController {
    @objc func didChangeNudgeDirection() {
        Settings.Repository.shared.changeSettings {
            $0.nudgeDirection = .init(rawValue: nudgeDirectionSegmentedControl.selectedSegmentIndex) ?? .upToSpeedUp
        }
    }
    
    @objc func didChangeNudgeSensitivity() {
        Settings.Repository.shared.changeSettings {
            $0.nudgeSensitivity = .init(rawValue: nudgeSensitivitySegmentedControl.selectedSegmentIndex) ?? .plusMinus005
        }
    }
}
