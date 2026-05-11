//
//  jfskfsd.swift
//  MidiJ
//
//  Created by me on 28/11/2022.
//

import OnionUI

protocol DependingOnTintColor {}

extension DependingOnTintColor where Self: SettingUpViews {
    
    func subscribeToTintColorChanges() {
        
        NotificationCenter.default.addObserver(forName: .tintColorDidChange, object: nil, queue: .main) { [weak self] _ in
            self?.setupViewColors()
        }
    }
}
