//
//  DocumentationView.swift
//  MidiJ
//
//  Created by me on 04/08/2023.
//

import Foundation
import OnionUI
import Combine
import UIKit

final class DocumentationView: StrictlySetupView {
    override func setupViewHierarchy() {
        super.setupViewHierarchy()
        addPinnedSubView {
            UIView()
                .addPinnedSubView(withPadding: .make(all: .Constants.spacing16)) {
                    UIStackView()
                        .verticalize()
                        .addArrangedSubViews {
                            SettingsView.SectionView(title: "What is midiJ?") {
                                UILabel()
                                    .mutated { it in
                                        it.attributedText = .from(markDowntext: .Copy.Documentation.intro)
                                        it.numberOfLines = 0
                                    }
                            }
                            SettingsView.SectionView(title: "Buttons") {
                                ButtonExplanationView(
                                    explainaitionText: .Copy.Documentation.menuButton,
                                    explanationSide: .right,
                                    button: MenuButton(menuVisibility: Just(MenuButton.MenuVisibility.initial))
                                )
                                ButtonExplanationView(
                                    explainaitionText: .Copy.Documentation.connectionButton,
                                    explanationSide: .left,
                                    button: ConnectionButton()
                                        .mutated(performMutations: { it in
                                            it.textLabel.text = .Copy.ConnectionType.midi
                                            it.connectionIndicator.isConnected = true
                                        }),
                                    buttonWidth: .Constants.commonWidth
                                )
                                ButtonExplanationView(
                                    explainaitionText: .Copy.Documentation.yPad,
                                    explanationSide: .right,
                                    button: YPad(),
                                    buttonWidth: .Constants.commonWidth,
                                    buttonHeight: .Constants.commonTallHeight
                                )
                                ButtonExplanationView(
                                    explainaitionText: .Copy.Documentation.nudgeValueButton,
                                    explanationSide: .left,
                                    button: BasicButton.tinyButton
                                        .mutated { it in
                                            it.textLabel.text = "0.42 %"
                                        },
                                    buttonWidth: .Constants.commonWidth
                                )
                                ButtonExplanationView(
                                    explainaitionText: .Copy.Documentation.tempoFader,
                                    explanationSide: .right,
                                    button: Fader()
                                        .mutated { it in
                                        // When set to 0.5 initial highlighting
                                        // isn't correct
                                        it.value = 1
                                    },
                                    buttonWidth: .Constants.commonWidth,
                                    buttonHeight: .Constants.commonTallHeight
                                )
                                ButtonExplanationView(
                                    explainaitionText: .Copy.Documentation.tempoValueButtton,
                                    explanationSide: .left,
                                    button: BasicButton.tinyButton
                                        .mutated { it in
                                            it.textLabel.text = "-0.02 %"
                                        },
                                    buttonWidth: .Constants.commonWidth
                                )
                                ButtonExplanationView(
                                    explainaitionText: .Copy.Documentation.bpmTapButtonExplanation,
                                    explanationSide: .right,
                                    button: BPMCounter()
                                        .mutated { it in
                                            it.bpmTextField.text = "120 bpm"
                                        },
                                    buttonWidth: .Constants.bigButtonDimensionSize,
                                    buttonHeight: .Constants.bigButtonDimensionSize
                                )
                                ButtonExplanationView(
                                    explainaitionText: .Copy.Documentation.cueButtonExplanation,
                                    explanationSide: .left,
                                    button: BigButton()
                                        .mutated(performMutations: { it in
                                            it.secundaryTitleLabel.text = .Copy.ButtonTitle.cue
                                        }),
                                    buttonWidth: .Constants.bigButtonDimensionSize,
                                    buttonHeight: .Constants.bigButtonDimensionSize
                                )
                                ButtonExplanationView(
                                    explainaitionText: .Copy.Documentation.playStopButtonExplanation,
                                    explanationSide: .right,
                                    button: BigButton()
                                        .mutated(performMutations: { it in
                                            it.secundaryTitleLabel.text = .Copy.ButtonTitle.play
                                        }),
                                    buttonWidth: .Constants.bigButtonDimensionSize,
                                    buttonHeight: .Constants.bigButtonDimensionSize
                                )
                            }
                            SettingsView.SectionView(title: "Connecting") {
                                UILabel()
                                    .mutated { it in
                                        it.attributedText = .from(markDowntext: .Copy.Documentation.connectingExplaination)
                                        it.numberOfLines = 0
                                    }
                            }
                        }
                }
                .verticalyScollable()
        }
    }
}

private extension CGFloat.Constants {
    static let commonWidth: CGFloat = 80
    static let commonTallHeight: CGFloat = 540
    static let bigButtonDimensionSize: CGFloat = 180
}
