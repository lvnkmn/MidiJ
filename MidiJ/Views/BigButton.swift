//
//  RoundedButton.swift
//  MidiJ
//
//  Created by work on 23/01/2022.
//

import OnionUI
import UIKit

class BigButton: UIButton, SettingUpViews {

    let secundaryTitleLabel = UILabel()
    var colorBasedOnIsHighlighted = DefaultBehavior.colorBasedOnIsHighlighted
    
    let backLight = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setupViewColors()
    }
    
    override var isHighlighted: Bool {
        didSet  {
            backLight.backgroundColor = colorBasedOnIsHighlighted(isHighlighted)
            secundaryTitleLabel.textColor = isHighlighted ? .Constants.highlightedTextColor : .Constants.primaryTextColor
        }
    }
    
    func setupViewColors() {
        isHighlighted = false
        layer.borderColor = UIColor.Constants.lightBorderColor.cgColor
        setTitleColor(.Constants.interactableBackgroundColor, for: .normal)
        backgroundColor = .Constants.interactableBackgroundColor
    }
    
    func setupViewProperties() {
        layer.borderWidth = .Constants.borderWidth2
        layer.cornerRadius = .Constants.cornerRadius24
        backLight.layer.cornerRadius = .Constants.cornerRadius19
        backLight.isUserInteractionEnabled = false
        secundaryTitleLabel.font = .systemFont(ofSize: .Constants.fontSize15, weight: .semibold)
    }
    
    func setupViewHierarchy() {
        addSubview(backLight)
        addSubview(secundaryTitleLabel)
    }
    
    func setupViewLayout() {
        backLight.translatesAutoresizingMaskIntoConstraints = false
        secundaryTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secundaryTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            secundaryTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            backLight.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            backLight.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            backLight.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            backLight.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
        ])
    }
}

extension BigButton {
    
    enum DefaultBehavior {
        static let colorBasedOnIsHighlighted = { (isHighlighted: Bool) -> UIColor in
            isHighlighted ? .Constants.pressedStateColor : .Constants.interactableBackgroundColor
        }
    }
}
