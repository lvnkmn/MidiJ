//
//  ButtonExplainaitionView.swift
//  MidiJ
//
//  Created by me on 23/07/2023.
//

import Foundation
import SwiftUI
import OnionUI

class ButtonExplanationView: StrictlySetupView {
    let explainaitionText: String
    let button: UIView
    let explanationSide: ExplainationSide
    let buttonWidth: CGFloat?
    let buttonHeight: CGFloat?
    
    internal init(
        explainaitionText: String,
        explanationSide: ExplainationSide,
        button: UIView,
        buttonWidth: CGFloat? = nil,
        buttonHeight: CGFloat? = nil
    ) {
        self.explainaitionText = explainaitionText
        self.button = button
        self.explanationSide = explanationSide
        self.buttonWidth = buttonWidth
        self.buttonHeight = buttonHeight
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViewHierarchy() {
        let explanationLabel = UILabel()
            .mutated { it in
                it.attributedText = .from(markDowntext: explainaitionText)
                it.numberOfLines = 0
                it.textAlignment = .justified
            }
        
        addPinnedSubView {
            UIStackView()
                .horizontalize()
                .mutated(performMutations: { it in
                    it.alignment = .center
                    it.spacing = .Constants.spacing11
                    it.distribution = .equalCentering
                })
                .addArrangedSubViews {
                    explanationSide == .left ? explanationLabel : nil
                    button
                        .mutated { it in
                            it.setContentCompressionResistancePriority(
                                .required,
                                for: .horizontal
                            )
                        }
                        .layedOutWith { layout in
                            if let buttonWidth {
                                layout.setWidth(to: buttonWidth)
                            }
                            if let buttonHeight {
                                layout.setHeight(to: buttonHeight)
                            }
                        }
                    explanationSide == .right ? explanationLabel : nil
                }
        }
    }
}

extension ButtonExplanationView {
    enum ExplainationSide {
        case right, left
    }
}
