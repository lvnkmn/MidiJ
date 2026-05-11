//
//  ViewController.swift
//  MidiJ
//
//  Created by User on 21/01/2022.
//

import OnionUI
import SourceSeeds
import UIKit

extension MainView {
    
    class Controller: UIViewController {
        
        var baseBPM: Double = .Constants.initialBPM {
            didSet {
                print("ℹ️ baseBPM is now \(baseBPM)")
                updateActualBPM()
            }
        }

        var pitchValue: Percentage = 0 {
            didSet {
                updateActualBPM()
                updatePitchValueLabel()
            }
        }
        
        var pitchBendValue: Percentage = 0 {
            didSet {
                updateActualBPM()
                updatepitchBendValueLabel()
            }
        }

        var nudgeSensitivity: Percentage {
            Settings.Repository.shared.settings.nudgeSensitivity.multiplier
        }
        
        let mainView: MainView

        private var performanceView: PerformanceView {
            mainView.performanceView
        }

        private var menuButtonsContainer: MenuButtonsContainer {
            mainView.menuContainer
        }
        
        private var wasPlayTouchedWhileCueIsHeld = false
        private lazy var connectionService = ConnectionService(settings: .Repository.shared.settings)
        private let settingsRepository = Settings.Repository()
        private let tapGestureRecognizer = UITapGestureRecognizer()
        
        private lazy var idiomBasedLayoutConfigurator: SettingUpViews = {
            switch traitCollection.userInterfaceIdiom {
            case .phone:
                return PhoneLayoutConfigurator(viewController: self)
            case .pad:
                return PadLayoutConfigurator(viewController: self)
            default:
                fatalError("Unsupported device ideom")
            }
        }()
        
        private var currentBeat = 0 {
            didSet {
                guard currentBeat != 0 else { return }
                print(currentBeat)
                pulseBPMCircle()
            }
        }

        private var centeredPitchFadeHapticFeedbackLimiter = TimeBasedCallLimiter(minimumTimeBetweenCalls: 0.5) {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }

        private let settingsViewController: UINavigationController
        
        init(settingsViewController: UINavigationController, viewModel: MainView.ViewModel) {
            self.settingsViewController = settingsViewController
                .mutated { it in
                    it.isNavigationBarHidden = true
                }
            mainView = .init(viewModel: viewModel)
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()

            NotificationCenter.default.addObserver(
                forName: .midiJsettingsDidChange,
                object: nil,
                queue: .main
            ) { [weak self] notification in
                guard
                    let self,
                    let settings = notification.object as? Change<Settings>
                else { return }
                
                self.connectionService.settings = settings.newValue
                if
                    settings.newValue.pitchRange != settings.oldValue.pitchRange ||
                    settings.newValue.pitchFaderDirection != settings.oldValue.pitchFaderDirection {
                    self.updatePitchValue()
                }
                self.updateYpadDirectionLabels()
                self.updatePitchFaderDirectionBasedProperties()
                self.updatePlayPauseButton()
                self.updateConnectionButtonTitle()
            }
            
            NotificationCenter.default.addObserver(forName: .tintColorDidChange, object: nil, queue: .main) { [weak self] _ in
                self?.setupViewColors()
            }
            
            connectionService.onConnect = { [weak self] in
                self?.menuButtonsContainer.connectionButton.connectionIndicator.isConnected = true
                self?.updateMenuButtonsHiddenState()
            }
            
            connectionService.onDisconnect = { [weak self] in
                self?.menuButtonsContainer.connectionButton.connectionIndicator.isConnected = false
                self?.updateMenuButtonsHiddenState()
            }
            
            connectionService.onBPMChange = { [weak self] bpm in
                logger.log("Actual BPM is now: \(bpm)")
                self?.updateBPMCounterAndIndicator()
            }
            
            connectionService.onPlaystateChanged = { [weak self] playState in
                self?.updatePlayPauseButton()
                self?.updateMenuButtonsHiddenState()
            }
            
            connectionService.onNextBeat = { [weak self] in
                self?.pulseBPMCircle()
            }
            
            performanceView.yPad.onEndNudgeByTap = { [weak self] in
                self?.pitchBendValue = 0
            }
            
            performanceView.yPad.onNudgeByTapUp = { [weak self] in
                guard
                    let self = self,
                    !self.performanceView.bpmCounterAndIndicator.bpmTextField.isFirstResponder
                else { return }
                switch Settings.Repository.shared.settings.nudgeDirection {
                case .downToSpeedUp:
                    self.pitchBendValue = -self.nudgeSensitivity
                case .upToSpeedUp:
                    self.pitchBendValue = self.nudgeSensitivity
                }
            }
            
            performanceView.yPad.onNudgeByTapDown = { [weak self] in
                guard
                    let self = self,
                    !self.performanceView.bpmCounterAndIndicator.bpmTextField.isFirstResponder
                else { return }
                switch Settings.Repository.shared.settings.nudgeDirection {
                case .downToSpeedUp:
                    self.pitchBendValue = self.nudgeSensitivity
                case .upToSpeedUp:
                    self.pitchBendValue = -self.nudgeSensitivity
                }
            }
            
            setupViews()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            UIApplication.shared.isIdleTimerDisabled = true
            performanceView.pitchFader.matchFaderCapPositionWithValue()
            performanceView.bpmCounterAndIndicator.secundaryTitleLabel.text = "Tap"
            
            if connectionService.playState == .stopped {
                pulseBPMCircle()
            }
        }
        
        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            
            coordinator.animate(alongsideTransition: { [weak self] _ in
                self?.performanceView.pitchFader.setNeedsDisplay()
            })
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            
            setupViewColors()
        }

        override var prefersStatusBarHidden: Bool {
            !shouldShowMenuBar
        }
    }
}

extension MainView.Controller: SettingUpViews {
    
    func setupViewProperties() {
        view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.addTarget(self, action: #selector(didTapView))
        
        performanceView.cueButton.secundaryTitleLabel.text = String.Copy.ButtonTitle.cue
        performanceView.playPauseButton.secundaryTitleLabel.text = String.Copy.ButtonTitle.play
        
        performanceView.playPauseButton.addTarget(self, action: #selector(didTouchDownPlayPauseButton), for: .touchDown)
        performanceView.cueButton.addTarget(self, action: #selector(didTouchDownCueButton), for: .touchDown)
        performanceView.cueButton.addTarget(self, action: #selector(didTouchUpCueButton), for: .touchUpInside)
        menuButtonsContainer.connectionButton.addTarget(self, action: #selector(didTapConnectButton), for: .touchUpInside)
        performanceView.pitchValueButton.addTarget(self, action: #selector(didTapTempoButton), for: .touchUpInside)
        performanceView.nudgeValueButton.addTarget(self, action: #selector(didTapNudgeValueButton), for: .touchUpInside)
        menuButtonsContainer.menuButton.addTarget(self, action: #selector(didTapMenuButton), for: .touchUpInside)

        menuButtonsContainer.connectionButton.textLabel.text = "Connect"
        
        performanceView.bpmCounterAndIndicator.onBPMChanged = { [weak self] bpm in
            self?.baseBPM = bpm
            self?.performanceView.pitchFader.reset()
        }
        
        performanceView.pitchFader.titleLabel.text = "Tempo"
        performanceView.pitchFader.value = 0.5
        performanceView.pitchFader.onValueChanged = { [weak self] value in
            guard let self else { return }
            if self.performanceView.bpmCounterAndIndicator.bpmTextField.isFirstResponder {
                self.performanceView.bpmCounterAndIndicator.parseInput()
            } else {
                self.updatePitchValue()
            }
            
            if value == 0.5 {
                self.centeredPitchFadeHapticFeedbackLimiter.callWhenAllowed()
            }
        }
        
        performanceView.yPad.titleLabel.text = "Nudge"
        performanceView.yPad.onYVelocityChanged = { [weak self] yVelocity in
            guard let self else { return }
            if self.performanceView.bpmCounterAndIndicator.bpmTextField.isFirstResponder {
                self.performanceView.bpmCounterAndIndicator.parseInput()
            } else {
                self.pitchBendValue = .percentage(
                    fromYpadVelocity: yVelocity,
                    consideringSettings: Settings.Repository.shared.settings
                )
                self.mainView.performanceView.yPad.dotsViews.mutated { dotsViews in
                    dotsViews.upperDotsView.isHeld = false
                    dotsViews.lowerDotsView.isHeld = false
                }
            }
        }
        
        updateYpadDirectionLabels()
        updatePitchFaderDirectionBasedProperties()
        updatePitchValueLabel()
        updatepitchBendValueLabel()
        updateBPMCounterAndIndicator()
        updateConnectionButtonTitle()
    }
    
    func setupViewHierarchy() {
        idiomBasedLayoutConfigurator.setupViewHierarchy()
        view.addSubViews {
            mainView
        }
    }
    
    func setupViewLayout() {
        performanceView.translatesAutoresizingMaskIntoConstraints = false
        
        idiomBasedLayoutConfigurator.setupViewLayout()
    }
    
    func setupViewColors() {
        view.backgroundColor = .Constants.backgroundColor
        idiomBasedLayoutConfigurator.setupViewColors()
    }
    
    func startDisplayingSettingsViewController() {
        addChild(settingsViewController)
        settingsViewController.didMove(toParent: self)
        
        view.addSubViews {
            settingsViewController.view?
                .setting(layerCornerRadius: .Constants.cornerRadius24)
                .setting(clipsToBounds: true)
        }
        
        settingsViewController.view.layout.pin(toEdge: .top, of: mainView.performanceView, shouldConsiderMargin: false)
        settingsViewController.view.layout.pin(toEdges: .horizontal, of: menuButtonsContainer, shouldConsiderMargin: false)
        settingsViewController.view.layout.pin(toEdge: .bottom, of: mainView.performanceView, shouldConsiderMargin: false)
    }
}

extension MainView.Controller {
    class PhoneLayoutConfigurator: SettingUpViews {
        let viewController: MainView.Controller
        
        internal init(viewController: MainView.Controller) {
            self.viewController = viewController
        }
        
        func setupViewLayout() {
            let vc = viewController
            vc.mainView.layout.pin(toEdge: .top, of: vc.view.safeAreaLayoutGuide)?.with(constant: .Constants.spacing08)
            vc.mainView.layout.pin(
                toEdges: .horizontal,
                withPadding: .make(horizontal: .Constants.spacing08)
            )
            vc.mainView.layout.pin(toEdge: .bottom, of: vc.view.safeAreaLayoutGuide)?.with(constant: -.Constants.spacing08)
        }
    }
    
    class PadLayoutConfigurator: SettingUpViews {
        let viewController: MainView.Controller
        
        internal init(viewController: MainView.Controller) {
            self.viewController = viewController
        }
        
        private let leadingBackground = UIImageView(image: .init(named: "PadBackgroundLeading")?.withRenderingMode(.alwaysTemplate))
        private let trailingBackground = UIImageView(image: .init(named: "PadbackgroundTrailing")!.withRenderingMode(.alwaysTemplate))
        
        private var vc: MainView.Controller { viewController }
        private var backgroundViews: [UIView] { [leadingBackground, trailingBackground] }
        
        func setupViewHierarchy() {
            backgroundViews.forEach(vc.view.addSubview)
        }
        
        func setupViewLayout() {
            vc.mainView.layedOutWith { layout in
                layout.setAspectRatio(to: 19.5/9)
                layout.centerHorizontally()
                layout.pin(toEdge: .left, withRelation: .greaterThanOrEqual)?.with(constant: .Constants.spacing08)
                layout.pin(toEdge: .right, withRelation: .lessThanOrEqual)?.with(constant: -.Constants.spacing08)
                layout.pin(toEdges: .vertical, of: vc.view.safeAreaLayoutGuide, withPadding: .make(vertical: .init(top: .Constants.spacing24, bottom: .Constants.spacing08)))
            }
            
            leadingBackground.layout.pin(toEdges: .bottomLeft)
            trailingBackground.layout.pin(toEdges: .bottomRight)
        }
        
        func setupViewColors() {
            backgroundViews.forEach {
                $0.tintColor = Settings.Repository.shared.settings.tintColor
            }
        }
    }
}

private extension MainView.Controller {

    func updatePitchValueLabel() {
        performanceView.pitchValueButton.textLabel.text = String(format: "%.2f %%", pitchValue)
    }
    
    func updatepitchBendValueLabel() {
        performanceView.nudgeValueButton.textLabel.text = String(format: "%.2f %%", pitchBendValue)
    }
    
    func updateBPMCounterAndIndicator() {
        performanceView.bpmCounterAndIndicator.bpmTextField.text = String.formatted(bpm: connectionService.bpm)
    }
    
    func updateActualBPM() {
        connectionService.bpm = max(min(round((baseBPM * ((pitchValue / 100) + 1) * ((pitchBendValue / 100) + 1)) * 100) / 100, .Constants.maximumBPM), .Constants.minimumBPM)
    }
    
    func updatePitchValue() {
        pitchValue = .percentage(
            fromFaderValue: performanceView.pitchFader.value,
            consideringSettings: Settings.Repository.shared.settings
        )
    }
    
    func updateYpadDirectionLabels() {
        switch Settings.Repository.shared.settings.nudgeDirection {
        case .downToSpeedUp:
            performanceView.yPad.topDirectionIndicator.text = String.Constants.slowerIndicator
            performanceView.yPad.bottomDirectionIndicator.text = String.Constants.fasterIndicator
        case .upToSpeedUp:
            performanceView.yPad.topDirectionIndicator.text = String.Constants.fasterIndicator
            performanceView.yPad.bottomDirectionIndicator.text = String.Constants.slowerIndicator
        }
    }
    
    func updatePitchFaderDirectionBasedProperties() {
        switch Settings.Repository.shared.settings.pitchFaderDirection {
        case .downToSpeedUp:
            performanceView.pitchFader.topDirectionIndicator.text = String.Constants.slowerIndicator
            performanceView.pitchFader.bottomDirectionIndicator.text = String.Constants.fasterIndicator
            performanceView.pitchFader.stripesView.shouldHighlightUpperStripes = true
        case .upToSpeedUp:
            performanceView.pitchFader.topDirectionIndicator.text = String.Constants.fasterIndicator
            performanceView.pitchFader.bottomDirectionIndicator.text = String.Constants.slowerIndicator
            performanceView.pitchFader.stripesView.shouldHighlightUpperStripes = false
        }
    }
    
    func updatePlayPauseButton() {
        switch connectionService.playState {
        case .stopped:
            performanceView.playPauseButton.secundaryTitleLabel.text = "Play"
            performanceView.playPauseButton.colorBasedOnIsHighlighted = BigButton.DefaultBehavior.colorBasedOnIsHighlighted
            performanceView.playPauseButton.backLight.backgroundColor = UIColor.Constants.interactableBackgroundColor
            performanceView.playPauseButton.secundaryTitleLabel.textColor = UIColor.Constants.primaryTextColor
        case .cueing:
            performanceView.playPauseButton.secundaryTitleLabel.text = "Resume"
        case .playing:
            performanceView.playPauseButton.secundaryTitleLabel.text = "Stop"
            performanceView.playPauseButton.colorBasedOnIsHighlighted = { _ in
                Settings.Repository.shared.settings.tintColor
            }
            performanceView.playPauseButton.isHighlighted = true
        }
    }
    
    @objc func didTouchDownPlayPauseButton() {
        if performanceView.cueButton.isHighlighted {
            wasPlayTouchedWhileCueIsHeld = true
        } else {
            if case PlayState.playing = connectionService.playState {
                connectionService.playState = .stopped
            } else if case PlayState.stopped = connectionService.playState {
                connectionService.playState = .playing
            }
        }
    }
    
    @objc func didTapView() {
        guard performanceView.bpmCounterAndIndicator.bpmTextField.isFirstResponder else { return }
        performanceView.bpmCounterAndIndicator.parseInput()
    }
    
    @objc func didTouchDownCueButton() {
        guard !performanceView.bpmCounterAndIndicator.bpmTextField.isFirstResponder else { return }
        
        connectionService.playState = .cueing
    }
    
    @objc func didTouchUpCueButton() {
        guard !performanceView.bpmCounterAndIndicator.bpmTextField.isFirstResponder else {
            performanceView.bpmCounterAndIndicator.parseInput()
            return
        }
        
        if !wasPlayTouchedWhileCueIsHeld {
            connectionService.playState = .stopped
        } else {
            connectionService.playState = .playing
        }
        wasPlayTouchedWhileCueIsHeld = false
    }
    
    @objc func didTapConnectButton() {
        guard connectionService.isConnected == false else { return }
        presentPopover(
            viewController: UIViewController().mutated(performMutations: { it in
                it.view = UIView()
                    .addPinnedSubView(withPadding: .init(top: 12, left: 12, bottom: 0, right: -12), {
                        UILabel()
                            .mutated(performMutations: { it in
                                it.text = .Copy.connectingExplaination
                                it.numberOfLines = 0
                                it.font = UIFont.systemFont(ofSize: .Constants.fontSize13, weight: .light)
                            })
                    })
            }),
            from: menuButtonsContainer.connectionButton
        )
    }
    
    @objc func didTapTempoButton() {
        presentPopover(
            viewController: PitchRangeViewController(),
            from: performanceView.pitchValueButton
        )
    }
    
    @objc func didTapNudgeValueButton() {
        presentPopover(
            viewController: NudgeSettingsViewController(),
            from: performanceView.nudgeValueButton
        )
    }
    
    @objc func didTapMenuButton() {
        return
    }
    
    func pulseBPMCircle() {
        if Settings.Repository.shared.settings.enableHapticFeedback {
            UIImpactFeedbackGenerator().impactOccurred()
        }
        
        performanceView.bpmCounterAndIndicator.backLight.backgroundColor = .Constants.bpmPulseColor
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: { [weak self] in
            self?.performanceView.bpmCounterAndIndicator.backLight.backgroundColor = .Constants.interactableBackgroundColor.withAlphaComponent(0.8)
        })
    }

    func updateConnectionButtonTitle() {
        menuButtonsContainer.connectionButton.textLabel.text = Settings
            .Repository.shared.settings.connectionType.localizedDescription
    }

    func updateMenuButtonsHiddenState() {
        setNeedsStatusBarAppearanceUpdate()
        mainView.isMenuVisible = shouldShowMenuBar
    }

    private var shouldShowMenuBar: Bool {
        !connectionService.isConnected ||
        connectionService.playState != .playing
    }
}

private extension MainView.Controller {
    
    func presentPopover(viewController: UIViewController, from button: UIView) {
        present(
            viewController.mutated(performMutations: { it in
                it.preferredContentSize = viewController.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                it.modalPresentationStyle = .popover
                it.presentationController?.delegate = self
                it.popoverPresentationController?.sourceView = button
                it.popoverPresentationController?.sourceRect = button.bounds
            }),
            animated: true
        )
    }
}

private extension CGSize {
    
    var popoverIndicatorAdjusted: CGSize {
        .init(width: width, height: height + .Constants.popOverIndicatorPadding)
    }
}

extension MainView.Controller: UIAdaptivePresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        .none
    }
}

private extension Double {
    
    static func percentage(fromFaderValue faderValue: Double, consideringSettings settings: Settings) -> Percentage {
        let multiplier = (faderValue * 2) - 1
        return multiplier * settings.pitchRange.multiplier * settings.pitchFaderDirection.multiplier * -1
    }
    
    static func percentage(fromYpadVelocity yVelocity: Double, consideringSettings settings: Settings) -> Percentage {
        guard yVelocity != 0 else {
            //Prevent -0.0 because of multiplier
            return 0
        }
        let leastSensitiveValue: Double = 1000
        let mostSensitiveValue: Double = 250
        let sensitivityRange = leastSensitiveValue - mostSensitiveValue
        let sensitivity = leastSensitiveValue - (sensitivityRange * settings.nudgeSensitivity.multiplier)
        
        let velocityDirectionMultiplier: Double = yVelocity >= 0 ? 1 : -1
        
        return max(min(pow(((yVelocity / sensitivity)), 2) * settings.nudgeDirection.multiplier * velocityDirectionMultiplier, 100), -100)
    }
}
