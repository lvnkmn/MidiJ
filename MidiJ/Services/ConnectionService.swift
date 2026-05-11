//
//  ConnectionService.swift
//  MidiJ
//
//  Created by work on 29/01/2022.
//

import Foundation
import QuartzCore

class ConnectionService {
    
    var onConnect: (()->())? {
        didSet {
            notifyAboutCurrentConnectionState()
        }
    }
    var onDisconnect: (()->())? {
        didSet {
            notifyAboutCurrentConnectionState()
        }
    }
    
    var onBPMChange: ((Double)->())?
    var onPlaystateChanged: ((PlayState)->())?
    
    /// Called every beat
    var onNextBeat: (()->())?
    
    var bpm: Double = .Constants.initialBPM {
        didSet {
            onBPMChange?(bpm)
            switch settings.connectionType {
            case .midi:
                MidiConnectionService.shared.set(tempo: bpm)
            }
        }
    }
    
    var curentBeat: Double {
        switch settings.connectionType {
        case .midi:
            MidiConnectionService.shared.timelinePosition
        }
    }
    
    var playState = PlayState.stopped {
        didSet {
            print(playState)
            switch playState {
            case .cueing:
                // When oldState was playing, we want to stop playing imediately when cueing
                if oldValue == .playing {
                    defer {
                        playState = .stopped
                    }
                    //Silence incorrect defer warning:
                    _ = 42
                } else {
                    play()
                }
            case .playing:
                //Since we can go from cueing to playing, we want to just continue playing in that case instead of restarting
                if oldValue != .cueing {
                    play()
                }
                
            case .stopped:
                stop()
            }
            onPlaystateChanged?(playState)
        }
    }
    
    var settings: Settings {
        didSet {
            guard oldValue.connectionType != settings.connectionType else { return }
            
            prepareConnectionsBasedOnActiveConnectionType()
        }
    }
    
    /// The modulo of the beat time, every new beat it's lower than the previous beattime
    /// therefor it can detect every next beat.
    private var currentBeatTimeMod: Double = 0 {
        didSet {
            if currentBeatTimeMod < oldValue {
                onNextBeat?()
            }
        }
    }
    /// Since ableton keeps it's own beat timeline independent of when starting, we keep the current beat mod at start
    /// so we can correct abletons beat timeline in order to make the beat happen in relation to the start.
    var currentBeatTimeModAtStart: Double = 0
    
    internal init(settings: Settings) {
        self.settings = settings
        
        MidiConnectionService.shared.set(tempo: bpm)
        
        prepareConnectionsBasedOnActiveConnectionType()
        
        NotificationCenter.default.addObserver(forName: .midiDestinationsDidChange, object: nil, queue: .main) { [weak self] _ in
            self?.updateMidiConnections()
        }
        
        let displayLink = CADisplayLink(target: self, selector: #selector(displayUpdate))
        displayLink.add(to: .current, forMode: .common)
    }

    var isConnected: Bool {
        switch settings.connectionType {
        case .midi:
            return isMidiConnected
        }
    }
}

private extension ConnectionService {
 
    var isMidiConnected: Bool {
        MidiConnectionService.shared.isConnected
    }
    
    func notifyAboutCurrentConnectionState() {
        switch settings.connectionType {
        case .midi:
            isMidiConnected ? onConnect?() : onDisconnect?()
        }
    }
    
    func prepareConnectionsBasedOnActiveConnectionType() {
        switch settings.connectionType {
        case .midi:
            prepareForMidiConnections()
        }
    }
    
    /// Called every view frame
    @objc func displayUpdate() {
        guard playState != .stopped else { return }
        switch settings.connectionType {
        case .midi:
            currentBeatTimeMod = fmod(curentBeat, 1)
        }
    }
    
    func play() {
        switch settings.connectionType {
        case .midi:
            MidiConnectionService.shared.startClock()
        }
        onNextBeat?()
    }
    
    func stop() {
        switch settings.connectionType {
        case .midi:
            MidiConnectionService.shared.stopClock()
        }
    }
    
    func prepareForMidiConnections() {
        updateMidiConnections()
    }
    
    func updateMidiConnections() {
        guard settings.connectionType == .midi else { return }
        MidiConnectionService.shared.connectToAllDestinations()
        if isMidiConnected {
            onConnect?()
        } else {
            onDisconnect?()
        }
    }
    
    private func updateBPMForActiveConnections() {
        switch settings.connectionType {
        case .midi:
            MidiConnectionService.shared.set(tempo: bpm)
        }
    }
}

extension Notification.Name {
    
    static let midiDestinationsDidChange = Notification.Name(rawValue: "midiDestinationsDidChange")
}
