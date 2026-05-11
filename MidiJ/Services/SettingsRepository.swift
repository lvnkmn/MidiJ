//
//  SettingsRepository.swift
//  MidiJ
//
//  Created by work on 01/02/2022.
//

import SourceSeeds

extension Settings {
    
    class Repository {
        
        static let shared = Repository()
        private(set) var settings = Settings.stored() {
            didSet {
                settings.store()
                NotificationCenter.default.post(
                    name: .midiJsettingsDidChange,
                    object: Change(oldValue: oldValue, newValue: settings)
                )
            }
        }
        
        /// Allows changing of settings which will cause `midiJsettingsDidChange` notification to be fired
        /// - Parameter updateSettings: closure in which settings can be updated
        func changeSettings(changeSetttings: (inout Settings)->()) {
            var changeableSettings = settings
            changeSetttings(&changeableSettings)
            settings = changeableSettings
            print("Settings are now:")
            print(settings)
        }
    }
}

private extension Settings {
    
    static func stored() -> Settings {
        guard let json = UserDefaults.standard.string(forKey: .Constants.settingsStorageKey),
              let jsonData = json.data(using: .utf8),
              let settings = try? JSONDecoder().decode(Settings.self, from: jsonData) else {
                  print("⚠️ failed to retrieve settings, using default")
                  return .init()
              }
        return settings
    }
    
    func store() {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            print("failed to encode \(self)")
            return
        }
        let jsonString = String.init(data: jsonData, encoding: .utf8)
        UserDefaults.standard.set(jsonString, forKey: .Constants.settingsStorageKey)
    }
}

private extension String.Constants {
    
    static let settingsStorageKey = "settingsStorageKey"
}

extension Notification.Name {
    
    static let midiJsettingsDidChange: Notification.Name = .init("midiJsettingsDidChange")
}
