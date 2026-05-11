//
//  FingerIndicator.swift
//  MidiJ
//
//  Created by work on 23/01/2022.
//

import OnionUI

class FingerIndicator: StrictlySetupView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(forName: .tintColorDidChange, object: nil, queue: .main) { [weak self] _ in
            self?.setupViewColors()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViewColors() {
        layer.borderColor = Settings.Repository.shared.settings.tintColor.cgColor
    }
    
    override func setupViewProperties() {
        layer.borderWidth = .Constants.borderWidth2
        layer.cornerRadius = frame.size.width / 2
    }
    
    override func setupViewLayout() {
        layout.activate {
            widthAnchor.constraint(equalToConstant: frame.size.width)
            heightAnchor.constraint(equalToConstant: frame.size.height)
        }
    }
}
