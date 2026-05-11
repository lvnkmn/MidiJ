//
//  BPMLabel.swift
//  MidiJ
//
//  Created by work on 12/02/2022.
//

import UIKit

class BPMCounter: BigButton {

    var onBPMChanged: ((_ bpm: Double)->())?
    var bpm: Double = .Constants.initialBPM {
        didSet {
            onBPMChanged?(bpm)
        }
    }

    let bpmTextField = UITextField()
        .mutated { it in
            it.textAlignment = .center
            it.adjustsFontSizeToFitWidth = true
        }
    
    private var previousTapTime: DispatchTime?
    private var previousTapIntervals: [Double] = [] {
        didSet {
            guard previousTapIntervals.count > 0 else { return }
            calculateBPM()
        }
    }
    
    private let longPressRecognizer = UILongPressGestureRecognizer()
    private let twoFingerTapRecognizer = UITapGestureRecognizer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet  {
            backLight.backgroundColor = isHighlighted ? .Constants.pressedStateColor : .Constants.interactableBackgroundColor
            bpmTextField.textColor = isHighlighted ? .Constants.highlightedTextColor : .Constants.primaryTextColor
        }
    }
    
    func parseInput() {
        stopInteractingWithBPMTextField()
        
        guard let text = bpmTextField.text,
              text.utf16.count > 0,
              let value = Double(text.replacingOccurrences(of: ",", with: ".")) else {
                  print("🎉 \(bpm)")
            revertBPMTextFieldToLastKnownBPM()
            return
        }
        if value > .Constants.maximumBPM {
            bpm = .Constants.maximumBPM
        } else if value < .Constants.minimumBPM {
            bpm = .Constants.minimumBPM
        } else {
            bpm = value
        }
    }
    
    override func setupViewProperties() {
        super.setupViewProperties()
        
        clipsToBounds = true
        bpmTextField.isUserInteractionEnabled = false
        bpmTextField.keyboardType = .decimalPad
        bpmTextField.returnKeyType = .done
        bpmTextField.font = .systemFont(ofSize: .Constants.fontSize20, weight: .heavy)
        bpmTextField.tintColor = .Constants.primaryTextColor
        bpmTextField.inputAccessoryView = DecimalPadToolbar().mutated { [weak self] in
            guard let self else { return }
            $0.doneButton.target = self
            $0.doneButton.action = #selector(self.didTapEnterManualBPMButton)
            $0.cancelButton.target = self
            $0.cancelButton.action = #selector(self.didTapCancelManualBPMButton)
        }
        addGestureRecognizer(longPressRecognizer)
        addGestureRecognizer(twoFingerTapRecognizer)
        longPressRecognizer.addTarget(self, action: #selector(didLongPressOrDoubleTapView))
        longPressRecognizer.minimumPressDuration = 0.5
        twoFingerTapRecognizer.numberOfTouchesRequired = 2
        twoFingerTapRecognizer.addTarget(self, action: #selector(didLongPressOrDoubleTapView))
        addTarget(self, action: #selector(Self.wasTapped), for: .touchDown)
    }
    
    override func setupViewHierarchy() {
        super.setupViewHierarchy()
        
        addSubview(bpmTextField)
    }
    
    override func setupViewLayout() {
        super.setupViewLayout()
        
        bpmTextField.layout.centerVertically()
        bpmTextField.layout.pin(toEdges: .horizontal)
    }
}

private extension BPMCounter {

    @objc func wasTapped() {
        if bpmTextField.isFirstResponder {
            parseInput()
            return
        }
        
        let now = DispatchTime.now()

        if let existingPreviousTapTime = previousTapTime {
            let currentTapInterval = Double(now.uptimeNanoseconds - existingPreviousTapTime.uptimeNanoseconds)
            if previousTapIntervals.count > 0 {
                let tapDifferencePercentage = abs(1 - (previousTapIntervals.average / currentTapInterval)) * 100
                if tapDifferencePercentage > 40 {
                    previousTapTime = nil
                    previousTapIntervals = []
                    print("ℹ️ Resetting BPM counter because of tap difference of \(tapDifferencePercentage) %")
                }
            }
            if previousTapTime != nil {
                previousTapIntervals += [currentTapInterval]
            }
        }
        previousTapTime = now
    }
    
    @objc func didLongPressOrDoubleTapView() {
        bpmTextField.isUserInteractionEnabled = true
        bpmTextField.text = ""
        bpmTextField.becomeFirstResponder()
    }
    
    func calculateBPM() {
        //Following two lines are needed to prevent double taps from being seen as BPM input,
        //this should not be needed when better handled. Will be removed as part of #13
        let calculatedBPM = .Constants.secondsPerMinute / (previousTapIntervals.average / .Constants.nanoSecondsPerSecond)
        guard calculatedBPM > .Constants.minimumBPM else { return }
        
        bpm = calculatedBPM
    }
    
    @objc func didTapCancelManualBPMButton() {
        stopInteractingWithBPMTextField()
        revertBPMTextFieldToLastKnownBPM()
    }
    
    @objc func didTapEnterManualBPMButton() {
        parseInput()
    }
    
    func revertBPMTextFieldToLastKnownBPM() {
        onBPMChanged?(bpm)
    }
    func stopInteractingWithBPMTextField() {
        bpmTextField.resignFirstResponder()
        bpmTextField.isUserInteractionEnabled = false
    }
}

private extension Array where Element == Double {
    
    var average: Double {
        let sum = reduce(Double(0), +)
        return sum / Double(count)
    }
}
