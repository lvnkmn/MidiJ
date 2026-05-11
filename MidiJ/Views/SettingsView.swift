//
//  SettingsViewController.swift
//  MidiJ
//
//  Created by me on 21/11/2022.
//

import UIKit
import OnionUI
import SourceSeeds

class SettingsView: StrictlySetupView, DependingOnTintColor {

    struct Events {
        let onTapDocumentationRow: () -> ()
        let onTapAcknowledgementsRow: () -> ()
    }
    
    let tintColorPreviewView = UIView()
        .mutated {
            $0.backgroundColor = Settings.Repository.shared.settings.tintColor
            $0.layer.cornerRadius = .Constants.cornerRadius16
        }
    
    let colorPicker = HueColorPicker()
        .mutated {
            $0.labelBackgroundColor = .Constants.primaryTextColor
            $0.cornerRadius = .colorPickerHeight / 2
        }
    
    let hapticFeedBackToggle = UISwitch()
        .mutated {
            $0.isOn = Settings.Repository.shared.settings.enableHapticFeedback
        }
    
    let showOnBoardingToggle = UISwitch()
        .mutated {
            $0.isOn = Settings.Repository.shared.settings.showOnBoardingUponNextLaunch
        }
    
    let showPitchFaderCapToggle = UISwitch()
        .mutated {
            $0.isOn = Settings.Repository.shared.settings.showPitchFaderCap
        }
    
    let events: Events
    
    init(events: Events) {
        self.events = events
        super.init(frame: .zero)
        subscribeToTintColorChanges()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViewColors() {
        colorPicker.currentColor = Settings.Repository.shared.settings.tintColor
        hapticFeedBackToggle.onTintColor = Settings.Repository.shared.settings.tintColor
        showOnBoardingToggle.onTintColor = Settings.Repository.shared.settings.tintColor
        showPitchFaderCapToggle.onTintColor = Settings.Repository.shared.settings.tintColor
        tintColorPreviewView.backgroundColor = Settings.Repository.shared.settings.tintColor
    }
    
    override func setupViewHierarchy() {
        addPinnedSubView(
            withPadding:
                    .init(
                        top: .zero,
                        left: .Constants.spacing16,
                        bottom: .Constants.spacing16,
                        right: -.Constants.spacing16
                    )
        ) {
            MainMenuView(title: "") {
                SectionView(title: "Preferences") {
                    traitCollection.userInterfaceIdiom.isIphone ? Row.toggleRow(text: "Haptic feedback", toggle: hapticFeedBackToggle) : nil
                    traitCollection.userInterfaceIdiom.isIphone ? SeparatorView() : nil
                    Row.toggleRow(text: "Show pitchfader cap", toggle: showPitchFaderCapToggle)
                    SeparatorView()
                }
                SectionView(title: "Tint Color") {
                    UIStackView()
                        .horizontalize()
                        .setting(allignment: .center)
                        .setting(spacing: .Constants.spacing20)
                        .addArrangedSubViews {
                            self.tintColorPreviewView
                                .layedOutWith { layout in
                                    layout.setWidth(to: 72)
                                    layout.setAspectRatio(to: 1)
                                }
                            self.colorPicker
                                .layedOutWith { layout in
                                    layout.setHeight(to: .colorPickerHeight)
                                }
                        }
                }
                SectionView(title: "Support") {
                    Row.chevronRow(text: .Copy.Documentation.title) // TODO: make coherent with settingsmenu
                        .tappable(events.onTapDocumentationRow)
                    SeparatorView()
                    Row.chevronRow(text: .Copy.SettingsMenu.CellTitle.acknowledgments)
                        .tappable(events.onTapAcknowledgementsRow)
                    SeparatorView()
                }
            }
        }
    }
}

extension SettingsView {
    
    class SectionView: UIView, SettingUpViews {
        
        let titleLabel = UILabel()
            .mutated {
                $0.font = .systemFont(ofSize: .Constants.fontSize20, weight: .semibold)
                $0.textColor = .Constants.secondaryTextColor
            }
        let vStack = UIStackView()
            .verticalize()
            .mutated {
                $0.spacing = .Constants.spacing16
            }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setupViews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        convenience init(title: String, @NilFilteredArrayBuilder _ provideArrangedSubviews: ()->[UIView]) {
            self.init()
            titleLabel.text = title
            provideArrangedSubviews().forEach(vStack.addArrangedSubview(_:))
        }

        func setupViewHierarchy() {
            addPinnedSubView {
                vStack.addArrangedSubViews {
                    titleLabel
                }
            }
        }
    }
}

private extension CGFloat {
    static let colorPickerHeight: CGFloat = 36
}

private extension UILabel {

    static var rowLabel: UILabel {
        .init().setting(font: .systemFont(ofSize: .Constants.fontSize20))
    }
}

private enum Row {
    static func toggleRow(text: String, toggle: UISwitch) -> UIView {
        UIStackView()
            .horizontalize()
            .addArrangedSubViews {
                UILabel.rowLabel
                    .setting(text: text)
                toggle
                UIView().layedOutWith { layout in
                    layout.setWidth(to: .Constants.spacing08)
                }
            }
    }
    
    static func chevronRow(text: String) -> UIView {
        UIStackView()
            .horizontalize()
            .addArrangedSubViews {
                UILabel.rowLabel
                    .setting(text: text)
                UIView()
                UIImageView(image: .init(named: "Chevron"))
                    .layedOutWith { layout in
                        layout.setWidth(to: 10)
                    }
            }
            .layedOutWith { layout in
                layout.setHeight(to: 22)
            }
    }
}
