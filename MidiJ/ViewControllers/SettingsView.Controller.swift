import OnionUI
import SourceSeeds
import UIKit

extension SettingsView {
    
    class Controller: UIViewController, SettingUpViews {
        
        private lazy var settingsView = SettingsView(
            events: .init(
                onTapDocumentationRow: { [weak self] in
                    guard let self else { return }
                    self.navigationController?.pushViewController(
                        .init()
                        .mutated { it in
                            it.view = DocumentationView()
                                .setting(backgroundColor: .Constants.interactableBackgroundColor)
                        },
                        animated: true
                    )
                }, onTapAcknowledgementsRow: { [weak self] in
                    guard let self else { return }
                    self.navigationController?.pushViewController(
                        .init()
                        .mutated { it in
                            it.view = AckowledgementsView()
                                .setting(backgroundColor: .Constants.interactableBackgroundColor)
                        },
                        animated: true
                    )
                }
            )
        )
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupViews()
        }
        
        func setupViewProperties() {
            [
                settingsView.hapticFeedBackToggle,
                settingsView.showOnBoardingToggle,
                settingsView.showPitchFaderCapToggle
            ].forEach {
                $0.addTarget(self, action: #selector(toggleValueDidChange(toggle:)), for: .valueChanged)
            }
            
            settingsView.colorPicker.delegate = self
            settingsView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
        
        func setupViewHierarchy() {
            view = settingsView
                .setting(backgroundColor: .Constants.settingsViewBackground)
        }
        
        @objc func toggleValueDidChange(toggle: UISwitch) {
            switch toggle {
            case settingsView.hapticFeedBackToggle:
                Settings.Repository.shared.changeSettings {
                    $0.enableHapticFeedback = toggle.isOn
                }
            case settingsView.showOnBoardingToggle:
                Settings.Repository.shared.changeSettings {
                    $0.showOnBoardingUponNextLaunch = toggle.isOn
                }
            case settingsView.showPitchFaderCapToggle:
                Settings.Repository.shared.changeSettings {
                    $0.showPitchFaderCap = toggle.isOn
                }
            default:
                break
            }
        }
    }
}

extension SettingsView.Controller: HueColorPickerDelegate {
    
    func valuePicked(_ color: UIColor, type: HueColorPicker.PickerType) {
        Settings.Repository.shared.changeSettings {
            $0.tintColor = color
        }
        
        NotificationCenter.default.post(name: .tintColorDidChange, object: nil)
    }
}
